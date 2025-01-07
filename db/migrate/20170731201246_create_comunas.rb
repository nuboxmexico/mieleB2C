class CreateComunas < ActiveRecord::Migration
  def change
    create_table :comunas do |t|
      t.string :name
      t.references :province, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
