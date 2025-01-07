Spree::Order.class_eval do
  acts_as_paranoid
  before_validation :clone_ship_address
  has_many :ship_addresses#, :through => :plural
  belongs_to :visit
  has_paper_trail on: []

  MIELE_STATES = %w[paid ready shipped delivered]

  def self.miele_states
    MIELE_STATES
  end

  def select_default_shipping
    if state != 'address'
      create_proposed_shipments
      shipments.find_each &:update_amounts
      update_totals
    end
  end

  def item_count
    super
    begin  
      return (self.line_items.sum(:quantity))
    rescue
      return 0
    end
  end

  def item_total
    total = 0
    self.line_items.each do |line_item|
      if !line_item.order.completed?
        if line_item.product.offer_price_available? and line_item.product.can_supply?
          line_item.price = line_item.product.master.prices[0].offer_price
          line_item.save
        end
      end
      total += line_item.price.to_i * line_item.quantity.to_i
    end
    return total
  end

  def update_prices_if_offer
    self.line_items.each do |line_item|
      if line_item.product.offer_price_available?
        line_item.price = line_item.product.master.prices[0].offer_price
        line_item.save
      end
    end
  end

  def check_offer(p)
    if !p.master.prices[0].offer_price.nil?
      if p.master.prices[0].offer_price < 1
        return true
      end
    end
    return false 
  end

  def is_invoice?
    return self.document_type == "bill"
  end

  def discount_stock
    MieleCoreApi.discount_stock_products_on_miele_core(self.line_items)
  end

  def restore_stock
    MieleCoreApi.restore_stock_products_on_miele_core(self.line_items)
  end

  def clone_ship_address
    if !self.is_invoice? and !["address","cart"].include?(self.state)
      self.bill_address = ship_address.try(:clone)
    end
    true
  end

  def self.repeat_last_complete_order(user,current_order, order)
    order_temp = user.orders.where(state: "complete").last
    current_order.empty!
    options  = {}
    errors = []
    order_temp.line_items.each do |item|
      variant  = Spree::Variant.find(item.variant_id)
      quantity = item.quantity.to_i
      line_item = order_temp.find_line_item_by_variant(variant, options)
      if line_item.sufficient_stock?
        order.contents.add(variant, quantity, options) 
      else 
        errors << variant.name
      end
    end
    order.update_line_item_prices!
    order.create_tax_charge!
    order.update_with_updater!
    return errors
  end
  
  def repeat_order(current_order,order)
    current_order.empty!
    options  = {}
    errors = []
    self.line_items.each do |item|
      variant  = Spree::Variant.find(item.variant_id)
      quantity = item.quantity.to_i
      line_item = self.find_line_item_by_variant(variant, options)
      if line_item.sufficient_stock?
        order.contents.add(variant, quantity, options) 
      else 
        errors << variant.name
      end
    end
    order.update_line_item_prices!
    order.create_tax_charge!
    order.update_with_updater!
    return errors
  end

  def self.download_orders
    orders = Spree::Order.where(state: 'complete', payment_state: 'paid')
    order_sheet = Axlsx::Package.new
    order_sheet.use_autowidth = true
    wb = order_sheet.workbook
    title = wb.styles.add_style(:b=> true, :sz=>12, :buser=> {:style => :thin, :color => "00000000",:edges => [:top,:left, :right, :bottom]})
    wb.add_worksheet(name: "Ordenes") do |sheet|
      headers = ["Número orden", "Email", "Fecha de compra", "Fecha pago", "Metodo pago", "Estado envío", "Método de envío", "Comuna", "Región", "Total"]
      sheet.add_row headers, style: title
      if orders.size > 0   
        orders.each do |order|
          row_t = [
          order.try(:number), 
          order.try(:email), 
          order.completed_at.strftime("%d/%m/%Y"), 
          order.payments.last.try(:updated_at).try(:strftime, "%d/%m/%Y"), 
          order.payments.last.try(:payment_method).try(:name), 
          Spree.t("shipment_states.#{order.try(:shipment_state)}"), 
          order.shipments.last.try(:shipping_rates).try(:first).try(:shipping_method).try(:name), 
          order.ship_address.try(:comuna).try(:name), 
          order.ship_address.try(:state).try(:name), 
          order.total]
          sheet.add_row row_t
        end       
      end
    end
    return order_sheet
  end

  def self.recover_cart
    begin
      orders = Spree::Order.where(recovered: false, state: ["cart", "address", "delivery", "payment"]).where.not(email: nil)
      orders.each do |order|
        Spree::OrderMailer.recovering_cart(order).deliver_later
      end
      orders.update_all(recovered: true)
      return true
    rescue Exception => e
      puts 'ERROR -> '+e
      return false
    end
  end

  def finish_order(current_spree_user, current_visit = nil)
    if current_visit
      self.visit = current_visit
    end

    if self.payments.size < 1
      pay_method = Spree::PaymentMethod.find_by(type: "Spree::Gateway::WebpayGateway")

      Spree::Payment.create(amount: self.total, 
                            payment_method_id: pay_method.id,
                            state: 'completed',
                            order: self)
    end

    self.deliver_order_confirmation_email

    self.update(payment_state: "paid",
                shipment_state: "ready",
                state: "complete")

    buyer_user = self.user

    if buyer_user
      buyer_user.save_addresses(self)

      buyer_user.create_or_update_on_core(self.document_type)
      self.send_products_to_miele_core
      self.send_addresses_to_miele_core
    end 
  end

  def deliver_order_confirmation_email
    begin
      unless self.confirmation_delivered
        Spree::OrderMailer.confirm_email(self).deliver_now
        update_column(:confirmation_delivered, true)
      end
    rescue Exception => e
      puts "Hubo un error al intentar envíar el correo"
    end
  end
  
  Spree::Address.class_eval do
    def require_zipcode?
      false
    end
  end

  def mda_and_sda_products
    products = []
    self.line_items.each do |item|
      if ['MDA', 'SDA'].include?(item.product.specific_attribute.category)
        products << item
      end
    end
    return products
  end

  def pai_products
    products = []
    self.line_items.each do |item|
      if item.product.specific_attribute.category == 'PAI'
        products << item
      end
    end
    return products
  end

  def to_b2b_api
    return {
      commune: self.try(:ship_address).try(:comuna).try(:name),
      total: self.try(:total).try(:to_i).try(:to_s),
      sell_date: self.try(:completed_at).try(:strftime, "%d/%m/%Y"),
      order: self.try(:number),
      products: self.line_items.map do |line_item|
        {
          tnr: line_item.try(:sku),
          quantity: line_item.try(:quantity).try(:to_i).try(:to_s),
          total_product: line_item.try(:total).try(:to_i).try(:to_s)
        }
      end
    }
  end 

  def special_data_object_order_for_b2b_quotation
    return{
      number:self.number,
      sell_date:self.completed_at,
      item_total:self.item_total,
      shipment_total:self.shipment_total.to_i,
      installation_total: self.instalation_value.to_i,
      total: self.total.to_i, 
      document_type:self.document_type,
      customer:{
        first_name:self.ship_address.firstname,
        last_name:self.ship_address.lastname,
        email:self.email,
        rut:self.ship_address.rut
      },
      ship_address:{
        rut:self.ship_address.rut,
        first_name:self.ship_address.firstname,
        last_name:self.ship_address.lastname,
        address:self.ship_address.address1,
        street_type: Spree::Address.street_types[self.ship_address.street_type],
        number: self.ship_address.number,
        apartment: self.ship_address.apartment,
        commune:self.ship_address.try(:comuna).name,
        city:self.ship_address.try(:comuna).try(:province).name,
        phone:self.ship_address.phone,
        region:{
          name:self.ship_address.try(:state).name,
          abbr:self.ship_address.try(:state).abbr
        }
      },
      bill_address:{
        rut:self.bill_address.rut,
        first_name:self.bill_address.firstname,
        last_name:self.bill_address.lastname,
        address:self.bill_address.address1,
        street_type: Spree::Address.street_types[self.bill_address.street_type],
        number: self.bill_address.number,
        apartment: self.bill_address.apartment,
        commune:self.bill_address.try(:comuna).name,
        city:self.bill_address.try(:comuna).try(:province).name,
        phone:self.bill_address.phone,
        region:{
          name:self.bill_address.try(:state).name,
          abbr:self.bill_address.try(:state).abbr
        }
      },
      payment:{
        payment_state:self.payment_state,
        tbk_token:self.tbk_token,
        tbk_transaction_id:self.tbk_transaction_id,
        webpay_data:self.webpay_data
      },
      products: self.line_items.map{|product| 
        {
          tnr:product.variant.sku,
          quantity:product.quantity,
          instalation:product.instalation,
          price: product.price
        }
      }
    } 
  end
  
  
  def line_items_resume
    return self.line_items.map{|l| {variant_id: l.variant_id, quantity: l.quantity}}.to_json
  end

  def total_without_product_offers
    return self.line_items.map{|l| l.variant.price}.sum
  end

  def total_without_products_in_offer
    total = 0
    self.line_items.each do |item| 
      unless item.variant.product.offer_price_available?
        total += item.price * item.quantity 
      end
    end
    return total
  end

  def total_adjustments
    total = 0
    self.adjustments.eligible.group_by(&:label).each do |label, adjustments|
      total += adjustments.sum(&:amount).abs
    end
    if self.line_item_adjustments.nonzero.exists?
      self.line_item_adjustments.nonzero.promotion.eligible.group_by(&:label).each do |label, adjustments|
        total += adjustments.sum(&:amount).abs
      end
    end

    return total
  end
  
  def self.update_miele_state
    Spree::Order.all.each do |order|
      if order.state == 'complete' && order.payment_state == 'paid'
        if order.shipment_state == 'ready'
          order.update_column(:miele_state, 'ready')
        elsif order.shipment_state == 'shipped'
          order.update_column(:miele_state, 'delivered')
        else
          order.update_column(:miele_state, 'paid')
        end
      end
    end
  end

  def set_miele_state
    if self.miele_state == 'paid'
      self.update_column(:miele_state, 'ready')
    elsif self.miele_state == 'ready'
      self.update_column(:miele_state, 'shipped')
    elsif self.miele_state == 'shipped'
      self.update_column(:miele_state, 'delivered')
    end
  end

  def webpay_object_data
    return {
      buy_order: self.number,
      session_id: self.guest_token,
      amount: self.total.to_i
    }
  end


  def send_products_to_miele_core
    user_in_core = MieleCoreApi.find_customer_by_email(self.email)
    if user_in_core
      user_id = user_in_core['data']['id']

      MieleCoreApi.assign_product_to_customer(user_id, self.variants.pluck(:core_id))
    end
  end

  def send_addresses_to_miele_core
    user_in_core = MieleCoreApi.find_customer_by_email(self.email)
    if user_in_core
      user_id = user_in_core['data']['id']
      additional_addresses = user_in_core['data']['additional_addresses']

      addresses = {
        'Despacho' => self.ship_address,
        'Instalación' => self.ship_address
      }

      addresses.each do |address_name, address|
        if (address_in_core = additional_addresses.find{|address| address['name'] == address_name})
          MieleCoreApi.update_customer_additional_address(address_in_core['id'], address.data_to_core(address_name))
        else
          MieleCoreApi.add_additional_address_to_customer(user_id, address.data_to_core(address_name))
        end
      end
    end
  end
end
