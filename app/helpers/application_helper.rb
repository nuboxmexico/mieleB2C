Spree::Admin::NavigationHelper.module_eval do 
  def link_to_delete(resource, options={})
    url = options[:url] || object_url(resource)
    name = options[:name] || Spree.t(:delete)
    options[:class] = "btn btn-danger btn-sm delete-resource"
    link_to_with_icon 'delete', name, url, options
  end
end

module ApplicationHelper
  include Pagy::Frontend
  def link_to_cart_custom(text = nil)
    text = text ? h(text) : Spree.t('cart')
    css_class = nil
    
    if simple_current_order.nil? or simple_current_order.item_count.zero?
      text = "<div>#{inline_svg_tag 'cart.svg'}</div>"
      css_class = 'full nohov'
    else
      text = "<div>
                #{inline_svg_tag 'cart.svg'}
                <span class='amount badge cart-badge'>
                  #{simple_current_order.item_count}
                </span>
              </div>"
      css_class = 'full nohov'
    end
    link_to (text.html_safe), "#", class: "cart-info #{css_class}"
  end
  
  def checkout_progress_custom(numbers: false)
      states = @order.checkout_steps
      states.unshift('complete')
      cart_div = '<div class="col col-xs-3 col-sm-1 circle-contain">'+
                    '<a href="'+cart_path+'">'+ 
                      '<div class="step-circle">'+
                        '<span class="text"><i class="fa fa-shopping-cart"></i></span>'+
                      '</div>'+
                      '<br/>'+
                      '<span class="step">'+Spree.t("order_state.cart")+'</span>'+
                    '</a>'+
                  '</div>'
      address_div = ''
      delivery_div = ''
      payment_div = ''
      items = states.each_with_index.map do |state, i|
        current_index = states.index(@order.state)
        state_index = states.index(state)
        text = Spree.t("order_state.#{state}").titleize
        icon = ''
        class_div = ''
        current_div = ''
        link = checkout_state_path(state)
        case state
        when 'address'
          icon = 'fa-address-book'
        when 'delivery'
          icon = 'fa-truck'
        when 'payment'
          icon = 'fa-credit-card'
        end
        if state_index < current_index
          # Pasos anteriores
        elsif state_index == current_index
          #Paso actual
          class_div = "circle-active"
        else
          ## Pasos siguientes
          class_div = "circle-disabled"
        end
        current_div ='<div class="col col-xs-3 col-sm-1 circle-contain '+class_div+'">'+
                        '<a href="'+link+'">'+ 
                          '<div class="step-circle">'+
                            '<span class="text"><i class="fa '+icon+'"></i></span>'+
                          '</div>'+
                          '<br/>'+
                          '<span class="step">'+text+'</span>'+
                        '</a>'+
                      '</div>'
        case state
        when 'address'
          address_div = current_div
        when 'delivery'
          delivery_div = current_div
        when 'payment'
          payment_div = current_div
        end
      end
      divider_div = '<div class="col hidden-xs col-sm-2">'+
                      '<div class="step-divider"></div>'+
                    '</div>' 
      checkout_steps = '<div class="row" align="center">'+
                          '<div class="col hidden-xs col-sm-1">'+
                          '</div>'+
                          cart_div +
                          divider_div +
                          address_div+
                          divider_div+
                          delivery_div+
                          divider_div+
                          payment_div+
                          '<div class="col hidden-xs col-sm-1">'+
                          '</div>'+
                        '</div>'
      checkout_steps.html_safe
  end

  def absolute_product_image(image)
    escape absolute_image_url(image.attachment.url)
  end

  def absolute_image_url(url)
    return url if url.starts_with? 'http'
    request.protocol + request.host + url
  end

  def category_bar_banner
    banner = PromotionalBanner.category_bar.where(active: "Activo").first
    if banner
      return image_tag banner.image.url(:medium), alt: banner.alt, class: 'img-responsive'
    end
  end

  # def cyberday
  #   ((DateTime.now > MieleConfig.last.start_oportunities) and (DateTime.now < MieleConfig.last.end_oportunities)) ? MieleConfig.last.title_oportunities : 'Oportunidades'
  # end

  def cyberday
    config = MieleConfig.last
    if config && config.start_oportunities && config.end_oportunities
      (DateTime.now > config.start_oportunities && DateTime.now < config.end_oportunities) ? config.title_oportunities : 'Oportunidades'
    else
      'Oportunidades'
    end
  end

  private

    def escape(string)
      URI.escape string, /[^#{URI::PATTERN::UNRESERVED}]/
    end
end
