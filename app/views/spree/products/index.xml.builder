xml.instruct! :xml, :version=>"1.0" 
xml.root{
  xml.catalogo{
  	@products.each do |product|
      xml.producto{
      	xml.id(product.sku)
  	  	xml.name(product.name)
  	  	xml.description(product.description)
  	  	xml.image((product.images.count > 0 ? asset_url(product.images.first.attachment.url(:product)) : ""))
  	  	xml.link(product_url(product))
  	  	xml.price(product.price.to_i)
  	  	xml.offer_price(product.real_price.to_i) if product.offer_price_available? && !product.master.prices.take.try(:offer_price).nil?
  	  }
    end
  }
}