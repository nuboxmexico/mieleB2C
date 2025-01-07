class AddSensitiveNameToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :sensitive_name, :string, :default => ""
  end
end
