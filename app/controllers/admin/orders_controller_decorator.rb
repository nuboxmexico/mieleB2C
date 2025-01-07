Spree::Admin::OrdersController.class_eval do
	def download_orders
		send_data Spree::Order.download_orders.to_stream.read, type: "application/xlsx", filename: "Órdenes_#{Date.today.strftime("%d-%m-%Y")}.xlsx"
	end

  def download_orders_summary
    send_data Spree::Order.download_orders_summary.to_stream.read, type: "application/xlsx", filename: "Órdenes_#{Date.today.strftime("%d-%m-%Y")}.xlsx"
    @from_button = params[:from_button]
  end

  def resend
    @shipment = Spree::Order.find_by(number: params[:id]).shipments.first
    begin
      Spree::ShipmentMailer.shipment_status_email(@shipment).deliver_later!
      flash[:success] = Spree.t(:order_email_resent)
    rescue Exception => e
      flash[:error] = "Ocurrió un error al intentar envíar el correo"
    end

    redirect_to :back
  end

  def index
    params.permit :from_button
    params[:q] ||= {}
    params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
    @show_only_completed = params[:q][:completed_at_not_null] == '1'
    params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
    params[:q][:completed_at_not_null] = '' unless @show_only_completed
    from_button = params[:from_button]

    # As date params are deleted if @show_only_completed, store
    # the original date so we can restore them into the params
    # after the search
    
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

    if params[:q][:created_at_gt].present?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
    end

    if params[:q][:created_at_lt].present?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end

    if @show_only_completed
      params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
      @search = Spree::Order.preload(:user).accessible_by(current_ability, :index).ransack(params[:q], state_eq: 'complete')
    else
      @search = Spree::Order.preload(:user).accessible_by(current_ability, :index).ransack(params[:q], state_not_null: true)
    end

    @miele_state_selector = Spree::Order::miele_states

    # lazy loading other models here (via includes) may result in an invalid query
    # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
    # see https://github.com/spree/spree/pull/3919
    @orders = @search.result(distinct: true)

    if @miele_state_selector.include? params[:q][:miele_state]
      @orders = @orders.where(miele_state: params[:q][:miele_state])
    end

    @miele_state_selected = params[:q][:miele_state] if params[:q][:miele_state].present?

    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt

    respond_to do |format|
      format.html {
        @orders = @orders.page(params[:page])
                         .per(params[:per_page] || Spree::Config[:orders_per_page])
      }
      format.xlsx { render xlsx: 'download_orders', filename: "Ordenes_#{Date.today.strftime("%d-%m-%Y")}.xlsx" }
    end
  end

  def update_massive_orders
    if params[:state] && params[:orders]
      next_state = params[:state]
      orders = params[:orders].values
      message = "Se realizó correctamente el cambio de estado de los pedidos seleccionados"
        orders.each do |order|
          shipment = Spree::Order.find(order).shipments.first
          shipment.order.set_miele_state
          case next_state
          when 'ready'
            Spree::ShipmentMailer.shipment_status_email(shipment).deliver_later!
          when 'shipped'
            shipment.ship!
          when 'delivered'
            Spree::ShipmentMailer.shipment_status_email(shipment).deliver_later!
          else
            message = "Estado no válido"
          end
        end
    else
      message = "No se realizó ningun cambio. Aseguresé de seleccionar un estado y los pedidos correspondientes"
    end
    redirect_to :back, notice: message
  end

  def ready
    @shipment = Spree::Order.find_by(number: params[:id]).shipments.first
    begin
      @shipment.order.set_miele_state
      Spree::ShipmentMailer.shipment_status_email(@shipment).deliver_later!
      message = "Pedido preparado correctamente"
    rescue => exception
      message = "No se pudieron preparar los productos del pedido"
    end
    redirect_to :back, notice: message
  end

  def ship
    @shipment = Spree::Order.find_by(number: params[:id]).shipments.first
    message = "No se pudo enviar el pedido"
    if !@shipment.shipped? && @shipment.can_ship?
      begin
        @shipment.order.set_miele_state
        @shipment.ship!
        message = "Pedido enviado correctamente"
      rescue => exception
      end
    end
    redirect_to :back, notice: message
  end

  def deliver
    @shipment = Spree:: Order.find_by(number: params[:id]).shipments.first
    message = "No se pudo enviar el pedido"
    if @shipment.shipped?
      begin
        @shipment.order.set_miele_state
        Spree::ShipmentMailer.shipment_status_email(@shipment).deliver_later!
        message = "Pedido entregado correctamente"
      rescue => exception
      end
    end
    redirect_to :back, notice: message
  end

  # Metodo para reenviar la orden que no se logro mandar para el b2b
  def resend_order_to_b2b
    @order = Spree::Order.find_by(number: params[:id])
    orders = Spree::Order.where(number: params[:id]) # caso especial para la funcion de jano

    errors=[]
		success = true

		begin 
      if  @order.send_to_api == false
        ApiSingleton.create_order_api(orders)
      end 

      if !@order.folio_b2b 
        if @order.user
          response = ApiSingleton.send_order_to_b2b_for_create_quotation(@order)

          if response["created"] == "fail"
            errors.push(response)
          end
        end 
      end 

			success = false if !errors.empty?

		rescue Exception => e
			success = false
			errors.push(e.to_s)
		end

		respond_to do |format|
			if success && errors.empty?

				format.html {redirect_to request.env["HTTP_REFERER"], notice: 'Orden Reenviada con Exito'}
			else
        a = File.new('ddd.txt','w')
        a.write(errors)
        a.close()
				format.html {redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error tratando de reenviar la orden', error:errors}
			end	
		end
  end


  def destroy
    @order = Spree::Order.find(params[:id])
    @order.destroy
    begin
      if @order.deleted?
        flash[:success] = Spree.t('notice_messages.order_deleted')
      else
        flash[:error] = Spree.t('notice_messages.order_not_deleted')
      end
    rescue ActiveRecord::RecordNotDestroyed => e
      flash[:error] = Spree.t('notice_messages.order_not_deleted')
    end

    respond_with(@order) do |format|
      format.html { redirect_to collection_url }
      format.js  { render_js_for_destroy }
    end
  end



end
