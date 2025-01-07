class AddFieldToSpreeStates < ActiveRecord::Migration
  def change
    add_column :spree_states, :mda_a, :integer
    add_column :spree_states, :mda_b, :integer
    add_column :spree_states, :mda_c, :integer
    add_column :spree_states, :sda_a, :integer
    add_column :spree_states, :sda_b, :integer
    add_column :spree_states, :sda_c, :integer
    add_column :spree_states, :pai_a, :integer
  end
end
