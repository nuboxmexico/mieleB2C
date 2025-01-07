class CreateProductComparableAttributes < ActiveRecord::Migration
  def change
    create_table :product_comparable_attributes do |t|
      t.references :spree_product, index: true, foreign_key: true
      t.references :comparable_attribute, index: true, foreign_key: true
      t.string :description

      t.timestamps null: false
    end
  end
end
