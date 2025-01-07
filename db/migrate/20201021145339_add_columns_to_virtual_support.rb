class AddColumnsToVirtualSupport < ActiveRecord::Migration
  def change
    add_column :virtual_supports, :subtitle, :text
    add_column :virtual_supports, :subdescription, :text
  end
end
