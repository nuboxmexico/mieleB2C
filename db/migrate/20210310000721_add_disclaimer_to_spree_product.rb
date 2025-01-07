class AddDisclaimerToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :disclaimer, :string
  end
end
