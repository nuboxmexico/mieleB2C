class AddFolioB2bToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :folio_b2b, :string
  end
end
