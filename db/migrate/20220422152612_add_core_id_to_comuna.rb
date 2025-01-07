class AddCoreIdToComuna < ActiveRecord::Migration
  def change
    add_column :comunas, :core_id, :bigint
  end
end
