class CreateComparableAttributes < ActiveRecord::Migration
  def change
    create_table :comparable_attributes do |t|
      t.string :name
      t.references :spree_taxon, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
