class AddInstalationToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :instalation, :boolean
  end
end
