class AddLineItemToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :line_item_id, :integer
  end
end
