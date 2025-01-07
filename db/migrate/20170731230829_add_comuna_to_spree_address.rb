class AddComunaToSpreeAddress < ActiveRecord::Migration
  def change
    add_reference :spree_addresses, :comuna, index: true, foreign_key: true
  end
end
