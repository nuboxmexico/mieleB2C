class ChangeShippingCostPrecisionToShippingCost < ActiveRecord::Migration
  def change
    change_column :spree_shipping_rates, :cost, :decimal, default: 0, precision: 10, scale: 2
  end
end
