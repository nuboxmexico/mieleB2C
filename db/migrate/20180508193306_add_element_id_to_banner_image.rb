class AddElementIdToBannerImage < ActiveRecord::Migration
  def change
    add_column :banner_images, :element_id, :string
  end
end
