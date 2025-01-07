module CheckoutsHelper
  def ship_address
    if current_spree_user and current_spree_user.ship_address
      return current_spree_user.ship_address
    else
      return @order.ship_address
    end
  end
end