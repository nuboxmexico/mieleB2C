Spree::OrderUpdater.class_eval do
  def update
    # order.select_default_shipping
    update_totals
    if order.completed?
      update_payment_state
      update_shipments
      update_shipment_state
      update_shipment_total
    end    
    run_hooks
    persist_totals
  end
end