class AddViewedToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :viewed, :boolean , :default => false
  end
end
