class CreateTagsProducts < ActiveRecord::Migration
  def change
    create_table :tags_products do |t|
      t.references :spree_product, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
