class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.references :spree_address, index: true, foreign_key: true
      t.references :spree_user, index: true, foreign_key: true
      t.references :spree_product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
