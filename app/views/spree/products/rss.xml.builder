xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", "xmlns:g" => "http://base.google.com/ns/1.0"){
  xml.channel{
    xml.title("#{Spree::Store.current.name}")
    xml.link("#{Spree::Store.current.url}")
    xml.description("#{Spree::Store.current.meta_description}")
    xml.language('es-cl')
    @products.each do |product|
      xml.item do
        xml.title(product.name)
        xml.sku(product.sku)
        xml.description(simple_format(((product.description.nil? || product.description == "") ? Spree.t(:product_has_no_description) : product.description.strip_html_tags)))      
        xml.author(Spree::Store.current.url)               
        xml.pubDate((product.available_on || product.created_at).strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(product_url(product))
        xml.guid(product.id)
        xml.price(product.price.to_i.to_s + " " + current_currency)
        
        if product.images.size > 0
          xml.tag!('g:image_link', image_url(product.images.first.attachment.url(:product)))
        elsif product.variant_images.size > 0
          xml.tag!('g:image_link', image_url(product.variant_images.first.attachment.url(:product)))
        end
        xml.tag!('g:availability', product.can_supply? ? "in stock" : "out of stock")
        xml.tag!('g:price', product.price.to_i.to_s + " " + current_currency)
        return_price = product.price
        if product.offer_price_available? && !product.master.prices.take.try(:offer_price).nil?
          if product.master.prices.take.offer_price > 0
            return_price = product.master.prices.take.offer_price
            xml.tag!('g:salePrice', return_price.to_i.to_s + " " + current_currency)
            xml.tag!('g:sale_price', return_price.to_i.to_s + " " + current_currency)
          end
        end
        xml.tag!('g:condition', 'new')
        xml.tag!('g:id', product.id)
        xml.tag!('g:brand', "Miele")
      end
    end
  }
}