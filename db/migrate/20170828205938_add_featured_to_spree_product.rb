class AddFeaturedToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :featured, :boolean, :default => false
  end
end
