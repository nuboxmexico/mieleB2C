class AddBooleanToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :instalation, :boolean, default: false
  end
end
