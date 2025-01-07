class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :name
      t.references :spree_state, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
