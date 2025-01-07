module OrdersHelper

  def order_items_by_courier
    return [@order.mda_and_sda_products, @order.pai_products]
  end

  def tracking_number_by_courier(index)
    if index == 0 and @order.shipments.first.alternative_tracking
      tracking_code = @order.shipments.first.alternative_tracking
      return (link_to tracking_code, 
                      "https://www.starken.cl/seguimiento?codigo=#{tracking_code}",
                      target: '_blank')
    elsif @order.shipments.first.tracking
      return (link_to @order.shipments.first.tracking, "https://alasxpress.com/", target: '_blank')
    end
  end

  def get_courier_name(index)
    if index == 0
      return 'Starken'
    else
      return 'Alas'
    end
  end
end