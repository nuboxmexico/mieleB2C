class CreateComparators < ActiveRecord::Migration
  def change
    create_table :comparators do |t|
      t.references :spree_user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
