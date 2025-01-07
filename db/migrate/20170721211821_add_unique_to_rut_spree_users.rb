class AddUniqueToRutSpreeUsers < ActiveRecord::Migration
  def change
  	add_index :spree_users, :rut, :unique => true
  end
end
