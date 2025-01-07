class CreateVirtualSupports < ActiveRecord::Migration
  def change
    create_table :virtual_supports do |t|
      t.string :name
      t.text :description
      t.boolean :active
      t.text :url

      t.timestamps null: false
    end
  end
end
