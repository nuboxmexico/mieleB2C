class AddFieldToBannerImages < ActiveRecord::Migration
  def change
    add_column :banner_images, :link_button, :boolean
  end
end
