class AddCompTokenToComparator < ActiveRecord::Migration
  def change
    add_column :comparators, :comp_token, :string
  end
end
