class AddCoreIdToSpreeVariant < ActiveRecord::Migration
  def change
    add_column :spree_variants, :core_id, :bigint
  end
end
