class AddWebpayNullifyToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :webpay_nullify, :boolean, :default => false
  end
end
