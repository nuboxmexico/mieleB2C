class AddInstAInstBInstCToSpreeStates < ActiveRecord::Migration
  def change
    add_column :spree_states, :inst_a, :integer
    add_column :spree_states, :inst_b, :integer
    add_column :spree_states, :inst_c, :integer
  end
end
#rails g migration add_inst_a_inst_b_inst_c_to_spree_states inst_a:integer inst_b:integer inst_c:integer