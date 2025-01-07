class CreatePromotionalBanners < ActiveRecord::Migration
  def change
    create_table :promotional_banners do |t|
      t.string :alt
      t.string :image_file_name
      t.integer :width
      t.integer :height
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :location

      t.timestamps null: false
    end
  end
end
