class AddDocumentTypeToSpreeOrders < ActiveRecord::Migration
  def change
    # Cambiar default dependiendo del tipo de comercio
    # boleta
    # factura
    add_column :spree_orders, :document_type, :string, :default => 'factura'
  end
end
