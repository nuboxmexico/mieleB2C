class AddEditableToStaticPage < ActiveRecord::Migration
  def change
    add_column :static_pages, :editable, :boolean
  end
end
