class AddMieleStateToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :miele_state, :string

    add_index :spree_orders, :miele_state
  end
end
