class RemoveIndexOnSpreeUsers < ActiveRecord::Migration
  def change
    remove_index :spree_users, name: "index_spree_users_on_rut"
  end
end
