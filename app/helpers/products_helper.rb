module ProductsHelper

  def depthest_taxon
    return @product.taxons.order(depth: :desc).first if @product
  end

  def show_mandatory_alert
    if @product.specific_attribute.try(:mandatory)
      return "<div class='mandatory-alert'>
                #{inline_svg('mandatorio.svg')}
                <p>
                  Este producto requiere de accesorios mandatorios para su uso
                </p>
              </div>".html_safe
    end
  end

  def show_disclaimer_alert
    unless @product.disclaimer.blank?
      return "<div class='disclaimer-alert'>
                #{inline_svg('disclaimer.svg')}
                <p>
                  #{@product.disclaimer}
                </p>
              </div>".html_safe
    end
  end

  def show_instalation_alert
    if @product.specific_attribute.try(:instalation)
      return "<div class='instalation-alert'>
                #{inline_svg('instalacion.svg')}
                <p>
                  Este producto requiere instalación por parte del equipo técnico de Miele para mantener la garantía
                </p>
              </div>".html_safe
    end
  end

  def discount_quantity(product)
    price = product.price
    offer_price = product.master.prices[0].offer_price
    if offer_price
      if offer_price > 0
        discount = 1 - offer_price.to_f/price.to_f
      else
        discount = 0
      end
    else
      discount = 0
    end
    return discount
  end
end