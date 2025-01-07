class AddTitleTextToBannerImage < ActiveRecord::Migration
  def change
    add_column :banner_images, :title_text, :text
  end
end
