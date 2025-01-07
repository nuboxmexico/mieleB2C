class FixCagasoJp < ActiveRecord::Migration
  def change
    if !Spree::Order.attribute_method? :deleted_at
      #add_column :spree_orders, :deleted_at, :datetime
      #add_index :spree_orders, :deleted_at
    end
  end
end
