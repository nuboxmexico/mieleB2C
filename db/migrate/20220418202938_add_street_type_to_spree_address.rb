class AddStreetTypeToSpreeAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :street_type, :integer
  end
end
