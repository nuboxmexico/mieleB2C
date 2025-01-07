class AddNumberAndApartmentToSpreeAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :number, :string
    add_column :spree_addresses, :apartment, :string
  end
end
