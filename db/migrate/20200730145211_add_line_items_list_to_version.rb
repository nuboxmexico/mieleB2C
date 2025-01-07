class AddLineItemsListToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :line_items, :text
  end
end
