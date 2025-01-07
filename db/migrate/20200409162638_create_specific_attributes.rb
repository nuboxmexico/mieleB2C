class CreateSpecificAttributes < ActiveRecord::Migration
  def change
    create_table :specific_attributes do |t|
      t.boolean :mandatory
      t.string :channel
      t.boolean :can_retire
      t.boolean :can_ship
      t.string :category
      t.boolean :built_in
      t.boolean :instalation
      t.boolean :outlet
      t.text :specs
      t.text :features
      t.text :technical_specs
      t.text :product_functions
      t.text :drink
      t.text :basket_design
      t.text :wash_program
      t.text :dry_program
      t.text :care
      t.text :security
      t.text :sustain
      t.text :accessories
      t.references :spree_product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
