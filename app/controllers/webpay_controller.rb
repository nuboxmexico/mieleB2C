class WebpayController < Spree::StoreController
	skip_before_action :verify_authenticity_token
	before_action :set_taxonomies
	layout '/spree/layouts/checkout'

#RUT: 11.111.111-1
#Clave: 123.
#Tarjeta bien: 4051885600446623
#Tarjeta mal: 5186059559590568
#CVV 123

	def return_url
    webpay_response = WebpayPlus.transaction_confirmation(params[:token_ws])
		if webpay_response and 
			 webpay_response['response_code'] == 0 and 
			 (order = Spree::Order.find_by(number: webpay_response['buy_order']))

			order.transaction do 
				order.update(tbk_token: params[:token_ws],
										 payment_state: 'pending',
										 state: 'complete',
										 webpay_data: webpay_response['legacy_format'],
										 completed_at: Time.now,
										 payment_state: 'paid',
										 miele_state: 'paid',
										 state_lock_version: 1,
										 tbk_transaction_id: webpay_response['session_id'])
				
			end

			redirect_to spree.webpay_success_path(token_ws: params[:token_ws])
		else
			redirect_to spree.webpay_error_path, alert: "Ha ocurrido un error con Webpay, por favor verifique si su orden se encuentra pagada."
		end
	end	

	def webpay_final_url
		if(params[:TBK_ID_SESION] == nil)
			@order = Spree::Order.find_by(tbk_token: params[:token_ws])
			redirect_to spree.webpay_success_path(token_ws: params[:token_ws])
		else
			redirect_to spree.webpay_nullify_path
		end
	end

	## Wepay data example
	# '["TRX_OK", "0824", "sda", "640000", "264110", "VD", "0", "2017-08-24T16:36:12.225-04:00", "https://webpay3gint.transbank.cl/filtroUnificado/voucher.cgi", "TSY", "0"]' 	  		
	# [state, accountingdate, cardnumber, amount, authorizationcode, paymenttypecode, responsecode, transactiondate, urlredirection, vci, sharesnumber]
	def nullify_order
		order = Spree::Order.find(params[:order_id])
		webpay_data = JSON.parse order.webpay_data
		authorizationCode = webpay_data[4]
		authorizedAmount = webpay_data[3]
		buyOrder = order.number
		nullifyAmount = webpay_data[3]
		if(webpay_data[5].to_s.strip == 'VD' )
			redirect_to :back, alert: "No se pueden anular ventas con tarjeta de débito."
		else
  		result = Spree::Webpay.nullify_transaction(params[:tbk_token], request.base_url.to_s, authorizationCode, authorizedAmount, buyOrder, nullifyAmount)
    	error = "No se ha podido anular, probablemente ya fue anulada."
    	if result['error_desc'].include? '274'
  			error = "No se encontró la transacción."
  		elsif result['error_desc'].include? '310' 
  			error = "La transacción ya ha sido anulada."
  		end
  		if(result['error_desc'] == 'TRX_OK')
				order.webpay_nullify = true
				order.save
    		redirect_to :back, notice: "Se ha anulado la orden satisfactoriamente"
  		else
  			redirect_to :back, alert: error
  		end
		end
	end
end

