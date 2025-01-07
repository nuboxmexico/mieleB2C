Spree::Variant.class_eval do
  has_many :spree_prices, class_name: 'Spree::Price', foreign_key: 'variant_id'

	def total_stock
		total_stock = 0
		self.stock_items.each do |item|
			total_stock += item.count_on_hand
		end
		return total_stock
	end

  def self.update_stocks_via_api(skus)
    begin
      stock_per_sku = MieleCoreApi.fetch_stock(skus)
      stock_per_sku.each do |sku, stock|
        if (variant = Spree::Variant.find_by(sku: sku))
          Spree::StockLocation.create_stock_item(variant) if variant.stock_items.empty?
          variant.stock_items[0].count_on_hand = stock
          variant.stock_items[0].save
        end
      end
    rescue Exception => e
      puts 'Ocurrió un error al actualizar el verificar el stock del producto. Intenta nuevamente'
    end
  end

  def self.update_core_ids
    Spree::Variant.where(core_id: nil).find_in_batches do |group|
      response = MieleCoreApi.find_products_by_tnr(group.map{ |variant| variant.sku })
      if response
        response['data'].each do |product_data| 
          Spree::Variant.find_by(sku: product_data['tnr'])
                        .update(core_id: product_data['id'])
        end
      end
    end
  end
end

