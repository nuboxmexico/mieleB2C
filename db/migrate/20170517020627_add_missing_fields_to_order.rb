class AddMissingFieldsToOrder < ActiveRecord::Migration

  def change
  	add_column :spree_orders, :tbk_token, :string, :default => '', index: true
  	add_column :spree_orders, :webpay_data, :string, :default => ''
  	add_column :spree_orders, :tbk_transaction_id, :string, :default => '', index: true
  end


end
