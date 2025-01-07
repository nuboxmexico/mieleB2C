class AddFeaturedToSpreeTaxon < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :featured, :boolean, :default => false
  end
end
