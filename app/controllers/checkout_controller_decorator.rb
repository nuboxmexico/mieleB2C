require 'openssl'
require 'base64'
module Spree
  CheckoutController.class_eval do
    skip_before_action :associate_user, only: [:webpay_success, :webpay_error, :webpay_nullify]
    skip_before_action :check_authorization, only: [:webpay_success, :webpay_error, :webpay_nullify]
    skip_before_action :check_registration, only: [:webpay_success, :webpay_error, :webpay_nullify]
    skip_before_action :ensure_sufficient_stock_lines, only: [:webpay_success, :webpay_error, :webpay_nullify]
    before_action :restore_stock, only: [:webpay_nullify, :webpay_error]
    layout :check_layout
    before_action :installation_value, only: [:edit]
    before_action :add_instalation_to_total, only: [:edit]

    

    def add_instalation_to_total
      if @order.instalation == false && @order.state == "payment"
        @order.update_line_item_prices!
        @order.update_prices_if_offer
        @order.create_tax_charge!
        @order.update_with_updater!
        simple_current_order.update_with_updater!
        final_order_value = @order.total + @installation_value
        @order.update_column(:instalation_value, @installation_value)
        @order.update_column(:total, final_order_value)
        @order.update_column(:instalation, true)
      end
    end



    def edit
      @services = Spree::Product.where(service: true)
      @country = Spree::Country.find_by(name: 'Chile')
      @previsit_service_variant = Spree::Variant.find_by(sku: "SERV01")
      @home_program_service_variant = Spree::Variant.find_by(sku: "PEM")
      @region_metropolitana_state = Spree::State.find_by(name: "Región Metropolitana de Santiago")
      @service_sku_collection = ["PEM", "SERV01"]
    end

    def update
      if params[:options] == "ticket"
        clone_dir
      end
      if params[:options]
       @order.document_type = params[:options]
      end
      
      if @order.state == "payment"
        payment = Spree::PaymentMethod.find(params[:order][:payments_attributes].first["payment_method_id"].to_i)
        if payment
          if payment.type.to_s == "Spree::Gateway::WebpayGateway"
            # Se descuenta el stock para "reservarlo" al pasar a webpay
            if @order.discount_stock
              if (webpay_response = WebpayPlus.init_transaction(@order))
                render html: webpay_response.body.html_safe 
              else
                redirect_to webpay_error_path 
                return
              end
            else
              flash[:error] = 'Hubo un error reservando el stock de la compra. Intente nuevamente.'
              redirect_to root_path
            end
          elsif payment.type.to_s == "Spree::Gateway::KhipuGateway" 
              
          elsif payment.type.to_s == "Spree::PaymentMethod::Check" 

          else
            redirect_to root_path
          end 
        end
        return
      end



      if !params[:use_delivery_date].nil?
        puts "--------------------paso 0"
        if !params[:order][:deliver_at_date].empty? && !params[:order][:deliver_at_time].empty?
          deliver_time = DateTime.strptime("#{params[:order][:deliver_at_date]} #{params[:order][:deliver_at_time]}", "%d/%m/%Y %H:%M:%S")
          @order.deliver_at = deliver_time
          if spree_current_user
            active_supplier_id = spree_current_user.supplier_id
          else
            active_supplier_id = cookies[:active_supplier].to_i
          end
          @order.approver_id = active_supplier_id
          @order.save
        end
      end

      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env) && @order.update_prices_if_offer
        puts "----paso 1  #{@order.item_total.to_s}"
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to(checkout_state_path(@order.state)) && return
        end
        @order.update_prices_if_offer
        puts "---------------------paso 2 #{@order.item_total.to_s} "
        if @order.completed?
          puts "---------------------paso 3 #{@order.item_total.to_s} "
          @current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        puts '--------------------paso 4 ' + @order.item_total.to_s 
        render :edit
      end
    end


    def webpay_success
      @order = Spree::Order.find_by(tbk_token: params[:token_ws])
      @order.finish_order(current_spree_user, current_visit)
      if @order.user
        ApiSingleton.create_order_api(Spree::Order.where(id: @order.id))
        ApiSingleton.send_order_to_b2b_for_create_quotation(Spree::Order.where(id: @order.id).first)
      end
    end

    def webpay_error
    end

    def webpay_nullify
    end

    def before_address
      # if the user has a default address, a callback takes care of setting
      # that; but if he doesn't, we need to build an empty one here
      
      @order.bill_address ||= Address.build_default
      @order.ship_address ||= Address.build_default if @order.checkout_steps.include?('delivery')
      @order.update_totals


    end

    def before_delivery
      return if params[:order].present?

      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)

      # only 1 paymentmethod? (Banktransfer)
      # select it!
      @order.select_default_payment unless @order.payment_required?

      #we select the shipping for the user
      @order.select_default_shipping
      @order.next

      #default logic for finalizing unless he can't select payment_method
      if @order.completed?
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"

        return redirect_to completion_route
      else
        return redirect_to checkout_state_path(@order.state)
      end
      # return if params[:order].present?
      # packages = @order.shipments.map(&:to_package)
      # @differentiator = Spree::Stock::Differentiator.new(@order, packages)
    end


    def load_order_with_lock
      @order = current_order(lock: true)
      if !(order = Spree::Order.where(tbk_token: params[:token_ws]).take).nil?
         @order = order
         return
      else
        redirect_to(spree.cart_path) && return unless @order
      end
    end

    def ensure_order_not_completed
      if !(order = Spree::Order.where(tbk_token: params[:token_ws]).take).nil?
        @order = order
        return
      else
        redirect_to spree.cart_path if @order.completed?
      end      
    end

    private
      def check_layout
        if action_name == "webpay_success"
          '/spree/layouts/spree_application'
        elsif action_name == "webpay_nullify"
          '/spree/layouts/spree_application'
        else
          '/spree/layouts/checkout'
        end
      end

      def clone_dir
        params[:order][:bill_address_attributes][:firstname] = params[:order][:ship_address_attributes][:firstname]
        params[:order][:bill_address_attributes][:lastname] = params[:order][:ship_address_attributes][:lastname]
        params[:order][:bill_address_attributes][:address1] = params[:order][:ship_address_attributes][:address1]
        params[:order][:bill_address_attributes][:address2] = params[:order][:ship_address_attributes][:address2]
        params[:order][:bill_address_attributes][:country_id] = params[:order][:ship_address_attributes][:country_id]
        params[:order][:bill_address_attributes][:state_id] = params[:order][:ship_address_attributes][:state_id]
        params[:order][:bill_address_attributes][:city] = params[:order][:ship_address_attributes][:city]
        params[:order][:bill_address_attributes][:zipcode] = params[:order][:ship_address_attributes][:zipcode]
        params[:order][:bill_address_attributes][:phone] = params[:order][:ship_address_attributes][:phone]
        params[:order][:bill_address_attributes][:comuna_id] = params[:order][:ship_address_attributes][:comuna_id]
        params[:order][:bill_address_attributes][:complementary_data] = params[:order][:ship_address_attributes][:complementary_data]
        params[:order][:bill_address_attributes][:rut] = params[:order][:ship_address_attributes][:rut]
        
      end

      def ensure_sufficient_stock_lines
        @order.line_items.map{|item| item.variant.product.nil? ? item.destroy : item}
        # byebug
        Spree::Variant.update_stocks_via_api(@order.line_items.map{|item| item.variant.sku})
        # byebug
        without_stock = @order.insufficient_stock_lines
        if without_stock.count > 0
          flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
          continue_with_purchase = @order.line_items.count > without_stock.count
          @order.insufficient_stock_lines.each do |item|
            @order.contents.remove_line_item(item)
          end
          if continue_with_purchase
            redirect_to checkout_state_path(current_order.checkout_steps.first)
          else
            redirect_to spree.root_path
          end
        end
      end

      def restore_stock
        @order.restore_stock
      end
  end
end

