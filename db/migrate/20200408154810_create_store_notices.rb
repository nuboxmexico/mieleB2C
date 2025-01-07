class CreateStoreNotices < ActiveRecord::Migration
  def change
    create_table :store_notices do |t|
      t.text :content
      t.string :link

      t.timestamps null: false
    end
  end
end
