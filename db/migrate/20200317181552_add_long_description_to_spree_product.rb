class AddLongDescriptionToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :long_description, :text
  end
end
