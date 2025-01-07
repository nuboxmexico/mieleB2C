class AddInstalationValueToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :instalation_value, :integer
  end
end
