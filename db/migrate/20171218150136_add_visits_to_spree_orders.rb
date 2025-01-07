class AddVisitsToSpreeOrders < ActiveRecord::Migration
  def change
    add_reference :spree_orders, :visit, index: true, foreign_key: true
  end
end
