class CreateBannerImages < ActiveRecord::Migration
  def change
    create_table :banner_images do |t|
      t.string :file_name
      t.integer :widht
      t.integer :height
      t.integer :size
      t.string :type
      t.string :alt

      t.timestamps null: false
    end
  end
end
