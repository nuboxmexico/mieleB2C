class AddServiceToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :service, :boolean, default: false
  end
end
