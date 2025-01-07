class DeleteBannerColumns < ActiveRecord::Migration
  def change
  	remove_column :banner_images, :file_name
	remove_column :banner_images, :size
	remove_column :banner_images, :banner_type
  end
end
