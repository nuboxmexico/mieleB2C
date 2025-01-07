class AddApiKeyForB2bToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :api_key, :string
  end
end
