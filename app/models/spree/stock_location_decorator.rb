Spree::StockLocation.class_eval do
  
  scope :propagate_all_variants, -> { where(propagate_all_variants: true) }

  def self.create_stock_item(variant)
    propagate_all_variants.each do |stock_location|
      stock_location.propagate_variant(variant)
    end
  end

end

