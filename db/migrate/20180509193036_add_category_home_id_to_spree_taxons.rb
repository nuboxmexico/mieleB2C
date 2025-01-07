class AddCategoryHomeIdToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :category_home_id, :string
  end
end
