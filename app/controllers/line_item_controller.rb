class LineItemController < Spree::OrdersController

	def destroy_item
		deleted = false
		begin
			item = current_order.line_items.find(params[:line_item])
			order = item.order
			order.contents.remove_line_item(item)
			order.update_line_item_prices!
    	order.update_prices_if_offer
    	order.create_tax_charge!
    	order.update_with_updater!
		rescue
			deleted = true
		end

		@order = order.reload
		respond_to do |format|
			format.html { redirect_to :back, notice: 'Se ha eliminado correctamente.' }
    	format.json { render json:  {resp: "OK"}}
  	end
	end

end