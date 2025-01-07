class AddViewedCountToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :viewed_count, :integer, :default => 0
  end
end
