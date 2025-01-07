Spree::ShipmentHandler.class_eval do
  private

  def send_shipped_email
    Spree::ShipmentMailer.shipment_status_email(@shipment.id).deliver_later!
  end

  def update_order_shipment_state
    order = @shipment.order
    new_state = Spree::OrderUpdater.new(order).update_shipment_state
    order.update_columns(
                          shipment_state: new_state,
                          updated_at: Time.current,
                        )
  end
end