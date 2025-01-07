class RenameTypeInBannerImage < ActiveRecord::Migration
  def change
  	rename_column :banner_images, :type, :banner_type
  end
end
