class AddAttributesToPromotionalBanner < ActiveRecord::Migration
  def change
    add_column :promotional_banners, :title, :string
    add_column :promotional_banners, :link, :string
    add_column :promotional_banners, :mobile_image_file_name, :string
    add_column :promotional_banners, :mobile_image_content_type, :string
    add_column :promotional_banners, :mobile_image_file_size, :integer
    add_column :promotional_banners, :mobile_image_updated_at, :datetime
  end
end
