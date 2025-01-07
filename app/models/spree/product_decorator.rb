Spree::Product.class_eval do
	attr_accessor :offer_price
	has_many :tags_products, foreign_key: 'spree_product_id'
	has_many :tags, through: :tags_products
	has_many :technical_documents, foreign_key: 'spree_product_id'
	alias :can_supply :can_supply?
  has_many :product_comparable_attributes, foreign_key: 'spree_product_id'
  has_many :comparable_attributes, through: :product_comparable_attributes
  has_one :specific_attribute, foreign_key: 'spree_product_id'

  after_create :set_specific_attribute

  scope :featured, -> {where(featured: true)
                        .where.not('discontinue_on IS NOT NULL AND discontinue_on <= ?', Time.current)
                      }

	def sensitive_name_t
		return self.name.downcase.mb_chars.normalize(:kd).gsub(/[^x00-\x7F]/n, '').to_s
	end

	def sell_total
		orders = self.orders.where(:state => 'complete')
		total = 0
		orders.each do |order|
			order.line_items.each do |item|
				if item.variant_id == self.master.id
    				total+= item.quantity.to_i
				end
			end
        end
        return total
	end

	def self.most_seller
		computed_time = Time.now - 12.month
    return Spree::Order.joins(line_items: { variant: :product })
            	        .where('spree_orders.completed_at >= :time_frame', time_frame: computed_time)
            	        .group("spree_products.id")
            	        .order("COUNT(spree_orders.id) DESC")
            	        .limit(10)
            	        .pluck("spree_products.id, spree_products.name, COUNT(spree_orders.id)")
	end

  def self.all_seller
  	computed_time = Time.now - 12.month
  	return Spree::Order.joins(line_items: { variant: :product })
                      .where('spree_orders.completed_at >= :time_frame', time_frame: computed_time)
                      .group("spree_products.id")
                      .order("COUNT(spree_orders.id) DESC")
                      .pluck("spree_products.id, spree_products.name, SUM(spree_orders.total)")
 	end

  def self.most_seller_products
	  computed_time = Time.now - 12.month
  	return Spree::Order.joins(line_items: { variant: :product })
                      .where('spree_orders.completed_at >= :time_frame', time_frame: computed_time)
                      .group("spree_products.id")
                      .order("COUNT(spree_orders.id) DESC")
                      .limit(4)
                      .pluck("spree_products.id")
	end

	def real_price
		return_price = self.price
		if self.master.prices.take.offer_price
			if self.master.prices.take.offer_price > 0
				return_price = self.master.prices.take.offer_price
			end
		end
		return_price
	end

	def discount_percentage
		discount = 0
    offer_price = self.master.prices.take.offer_price
		if self.price > 0 and offer_price and offer_price >= 0 and self.price > offer_price
			discount = (1 - (offer_price.to_f / self.price.to_f)) * 100
		end
		return discount.round
	end

  def comparable_attrs_comparison
    attrs = self.product_comparable_attributes
                .includes(:comparable_attribute)
                .order(id: :asc)
    return attrs.map{|a| [a.comparable_attribute.name, a.description]}.to_h
  end

  def comparable_attrs
    return self.product_comparable_attributes
               .includes(:comparable_attribute)
               .order(id: :asc)
  end

  def depthest_taxon
    return self.taxons.order(depth: :desc).first
  end

  def offer_price_available?
    available = false
    product_price = self.master.prices[0]
    if product_price && 
       product_price.offer_price.present? && 
       product_price.offer_price > 0 && 
       product_price.price > product_price.offer_price
      if product_price.offer_price_start
        if product_price.offer_price_end
          # Las dos fechas fueron ingresadas
          available = Date.today.between?(product_price.offer_price_start, 
                                          product_price.offer_price_end)
        else
          # Solo se ingresó fecha de inicio
          available = Date.today >= product_price.offer_price_start
        end
      else
        if product_price.offer_price_end
          # Sólo se ingresó fecha de fin
          available = Date.today <= product_price.offer_price_end
        else
          # No se ingresó ninguna fecha
          available = true
        end
      end
    end
    return available
  end

  def current_stock
    return self.stock_items[0].try(:count_on_hand).to_i
  end

  def to_quote?
    specific_attribute = self.specific_attribute
    return (specific_attribute.try(:mandatory) or 
           (specific_attribute.try(:built_in) and self.current_stock == 0))
  end

  def can_supply?
    variants_including_master.any?(&:can_supply?)
  end

  private 

    def set_specific_attribute
      unless self.specific_attribute
        self.update(specific_attribute: SpecificAttribute.create)
      end    
    end
end
