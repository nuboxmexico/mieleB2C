class AddImageToBannerImage < ActiveRecord::Migration
  def up
    add_attachment :banner_images, :image
  end
 
  def down
    remove_attachment :banner_images, :image
  end
end
