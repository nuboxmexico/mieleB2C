class AddTrackingInfoToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :tracking_info, :string
  end
end
