class AddNewTributesToStaticPage < ActiveRecord::Migration
  def change
    add_column :static_pages, :background_image_file_name, :string
    add_column :static_pages, :background_image_content_type, :string
    add_column :static_pages, :background_image_file_size, :integer
    add_column :static_pages, :background_image_updated_at, :timestamp
  end
end
