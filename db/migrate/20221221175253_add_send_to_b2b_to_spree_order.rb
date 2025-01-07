class AddSendToB2bToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :send_to_b2b, :boolean, :default => false
  end
end
