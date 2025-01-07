class RenameUrlToStaticPage < ActiveRecord::Migration
  def change
    rename_column :static_pages, :url, :slug
  end
end
