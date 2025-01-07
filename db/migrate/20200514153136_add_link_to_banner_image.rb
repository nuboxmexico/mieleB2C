class AddLinkToBannerImage < ActiveRecord::Migration
  def change
    add_column :banner_images, :link, :string
  end
end
