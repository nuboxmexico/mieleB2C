module Spree
	OrdersController.class_eval do

		def custom_apply_coupon
			if params[:order] && params[:order][:coupon_code_custom]
       @order = Spree::Order.find_by(number: params[:order][:number])
       params[:order_token] = @order.guest_token
       @order.update(coupon_code: params[:order][:coupon_code_custom])
       handler = PromotionHandler::Coupon.new(@order).apply
       if handler.promotion && 
        (handler.promotion.promotion_actions.take.type.downcase.include?("freeshipping")) && 
        handler.error.present? && 
        !(handler.error.include? "El código del cupón ya ha sido aplicado a este pedido")
        handler.error = "Este cupón debe ser aplicado una vez indicada su dirección, en el paso de envío."
      end
      @errors = handler.error
      respond_to do |format|
        format.js 
      end
    end
  end

  def update
    if @order.contents.update_cart(order_params) && 
      @order.update_prices_if_offer(@order.line_items)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end	
  end

    # Adds a new item to the order (creating a new order if none already exists)
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}
    on_hand_stock = variant.product.stock_items[0].try(:count_on_hand).to_i

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647) # and variant.can_supply?
      if variant.product.service and order.line_items.find_by(variant: variant)
        @error = 'Solo puedes agregar una vez los servicios al carro.'
      else
        begin
          Spree::Variant.update_stocks_via_api([variant.sku])
          order.contents.add(variant, quantity, options)
          order.update_line_item_prices!
          order.update_prices_if_offer
          order.create_tax_charge!
          order.update_with_updater!
          PaperTrail::Version.create(item_type: 'Spree::Order', item_id: order.id, event: 'Add Product', line_item_id: variant.id, line_items: order.line_items_resume)
        rescue ActiveRecord::RecordInvalid => e
          @error = e.record.errors.messages.values.join(", ")
        rescue StandardError => e
          @error = e.message
        end
      end
    else
    	if on_hand_stock > 1
        @error = Spree.t(:insufficient_stock_plural, on_hand: on_hand_stock)
      else
        @error = Spree.t(:insufficient_stock, on_hand: on_hand_stock)
      end
    end

   respond_with(order) do |format|
      if @error
        format.html{
          flash[:error] = @error
          redirect_back_or_default(spree.root_path)
        }
      else
        format.html { redirect_to :back , notice: 'Se ha agregado el producto a su carro.' }
      end
      format.js
    end
  end

  def populate_service
    @order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}
    on_hand_stock = variant.product.stock_items[0].try(:count_on_hand).to_i

    if @order.line_items.find_by(variant: variant)
      @error = 'Solo puedes agregar una vez los servicios al carro.'
      @success = false
    else
      begin
        @order.contents.add(variant, quantity, options)
        @order.update_prices_if_offer
        @order.create_tax_charge!
        @order.update_with_updater!
        PaperTrail::Version.create(item_type: 'Spree::Order', item_id: @order.id, event: 'Add Product', line_item_id: variant.id, line_items: @order.line_items_resume)
        @success = true 
      rescue ActiveRecord::RecordInvalid => e
        @error = e.record.errors.messages.values.join(", ")
        @success = false
      end
    end

    respond_to do |format|
      format.js
    end
  end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate_ajax
      @order    = current_order(create_order_if_necessary: true)
      variant  = Spree::Variant.find(params[:variant_id])
      quantity = params[:quantity].to_i
      options  = params[:options] || {}
      # 2,147,483,647 is crazy. See issue #2695.
      if quantity.between?(1, 2_147_483_647)
        begin
          @order.contents.add(variant, quantity, options)
          @order.update_line_item_prices!
          @order.update_prices_if_offer
          @order.create_tax_charge!
          @order.update_with_updater!
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.messages.values.join(", ")
        rescue StandardError => e
          error = e.message
        end
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end
      if error
        respond_to do |format|
         format.js  { render :json => { :error => error }, status: 501 }
       end
     else
      respond_to do |format|
       format.js	
     end
   end
 end

    #metodo que repite la última compra hecha por el usuario
    def repeat_last_complete_order
    	success = false
    	errors = ""
    	unless current_spree_user.nil?

        order = current_order(create_order_if_necessary: true)
        begin
          errors = Spree::Order.repeat_last_complete_order(current_spree_user, current_order, order)
          success = true
        rescue
          success = false
        end
      end
      respond_repeat(errors, success)
    end

    #repite cualquier orden
    def repeat_order
    	temp_order = Spree::Order.find(params[:order_id])
    	success = false
    	errors = ""
    	unless current_spree_user.nil?

       order = current_order(create_order_if_necessary: true)
       begin
         errors = temp_order.repeat_order(current_order, order)
         success = true
       rescue
        success = false
      end
    end
    respond_repeat(errors, success)
  end

  def update_item_quantity
    begin
    	item = Spree::LineItem.find_by(id: params[:id])
    	@order = item.order
    	if params[:step] == 'up'
    		quantity = 1
    	elsif params[:step] == 'down' and item.quantity > 1
    		quantity = -1
    	end
      if item.variant.total_stock >= item.quantity + quantity
        @order.contents.add(item.variant, quantity, {})
      else
        item.update(quantity: item.variant.total_stock)
        @adjust_quantity_to_available_stock_error = 'Se actualizó la cantidad del producto al stock disponible'
      end

      PaperTrail::Version.create(item_type: 'Spree::Order', item_id: @order.id, event: "Update Quantity to #{quantity}", line_item_id: item.variant.id, line_items: @order.line_items_resume)

    	@order.update_line_item_prices!
    	@order.update_prices_if_offer
    	@order.create_tax_charge!
    	@order.update_with_updater!
    	simple_current_order.update_with_updater!
    rescue ActiveRecord::RecordInvalid => e
      @error = e.record.errors.messages.values.join(", ")
    rescue StandardError => e
      @error = e.message
      # @error = 'Ocurrió un problema al modificar la cantidad. Intenta nuevamente.'
    end

  	respond_to do |format|
  		format.js
  	end
  end

  def update_item_installation
    begin
    	item = Spree::LineItem.find_by(id: params[:id])
    	@order = item.order
    	unless item.nil?
        item.update(instalation: !item.instalation)
      end
    	@order.update_line_item_prices!
    	@order.update_prices_if_offer
    	@order.create_tax_charge!
    	@order.update_with_updater!
    	
      simple_current_order.update_with_updater!
    rescue ActiveRecord::RecordInvalid => e
      @error = e.record.errors.messages.values.join(", ")
    rescue StandardError => e
      @error = e.message
    end
    
    installation_value
    final_order_value = @order.total + @installation_value
    @order.update_column(:instalation_value, @installation_value)
    @order.update_column(:total, final_order_value)
    @order.update_column(:instalation, true)
  
    respond_to do |format|
  		format.js
  	end
  end

  def remove_item
    begin
      item = Spree::LineItem.find_by(id: params[:id])
    	@order = item.order
      @removed = item.variant_id
    	@order.contents.remove_line_item(item)
			@order.update_line_item_prices!
    	@order.update_prices_if_offer
    	@order.create_tax_charge!
    	@order.update_with_updater!
      PaperTrail::Version.create(item_type: 'Spree::Order', item_id: @order.id, event: 'Remove Product', line_item_id: item.variant.id, line_items: @order.line_items_resume)
    rescue StandardError => e
      @error = 'Ocurrió un problema al quitar el producto. Intenta nuevamente.'
    end
  	respond_to do |format|
  		format.js {render template: 'spree/orders/update_item_quantity'}
  	end
  end

  def update_shipping_address_ajax
  	# @order = Spree::Order.find(params[:id])
  	simple_current_order.ship_address.update(state_id: params[:state_id],
                                             comuna_id: params[:comuna_id])
    simple_current_order.refresh_shipment_rates
    simple_current_order.update_with_updater!
    @order = simple_current_order
    respond_to do |format|
      format.js {render template: 'spree/orders/update_item_quantity'}
    end
  end

  def show_apply_coupon_form
    @order = simple_current_order
  end

  private 
    def respond_repeat(errors, success)
      err = ""
      if errors.size > 0
        err = errors.to_s
        err.slice! "["
        err.slice! "]"
        err.slice! '"'
        err.slice! '"'
        err = " Algunos productos ("+ err + "), no han podido ser cargados por stock."
      end
      respond_to do |format|
        if success
          format.html { redirect_to :back, notice: 'Se ha cargado su compra satisfactoriamente.' + err }
        else
          format.html { redirect_to :back, alert: 'No se ha podido cargar su compra.'}
        end
      end
    end
  end
end

