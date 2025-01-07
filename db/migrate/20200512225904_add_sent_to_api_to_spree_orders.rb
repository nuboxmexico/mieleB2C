class AddSentToApiToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :send_to_api, :boolean, default: false
  end
end
