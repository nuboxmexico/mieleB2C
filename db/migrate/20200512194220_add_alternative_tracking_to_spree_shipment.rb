class AddAlternativeTrackingToSpreeShipment < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :alternative_tracking, :string
  end
end
