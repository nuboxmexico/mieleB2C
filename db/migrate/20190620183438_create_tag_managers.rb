class CreateTagManagers < ActiveRecord::Migration
  def change
    create_table :tag_managers do |t|
      t.string :tag_manager_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
