class CreateComparatorItems < ActiveRecord::Migration
  def change
    create_table :comparator_items do |t|
      t.references :comparator, index: true, foreign_key: true
      t.references :spree_variant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
