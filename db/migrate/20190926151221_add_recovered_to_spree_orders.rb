class AddRecoveredToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :recovered, :boolean, default: false
  end
end
