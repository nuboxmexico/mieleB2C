class AddComplementaryDataToSpreeAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :complementary_data, :string
  end
end
