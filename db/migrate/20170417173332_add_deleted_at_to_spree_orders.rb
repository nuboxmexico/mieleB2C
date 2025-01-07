class AddDeletedAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :deleted_at, :datetime
    add_index :spree_orders, :deleted_at
  end
end
