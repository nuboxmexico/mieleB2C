require 'mercadopago.rb'

class MercadoPagoSpree

	MERCADOPAGO_BASEURL = "https://api.mercadopago.com"
  
  ## Checkout preferences, para configurar configurar, durante el proceso de pago, 
  ## toda la información del artículo, cualquier medio de pago aceptado y muchas otras opciones.
  # GET # PUT para otener o actualizar la orden, deacuerdo al método con que se llama la URL
  CHECKOUT_PRECERENCE = "/checkout/preferences/:id "
  # POST
  CREATE_CHECKOUT_PREFERENCE = "/checkout/preferences"

  ## Merchant orders, permite realizar un seguimiento del estado de un pedido, agrupar elementos, pagos y envíos.
  # GET # PUT para otener o actualizar la orden, deacuerdo al método con que se llama la URL
  MERCHANT_ORDER = "/merchant_orders/:id"
  # POST
  CREATE_MERCHANT_ORDER= "/merchant_orders"
  
  ## Preapproval orders Recupera información sobre una autorización para el débito de una tarjeta de crédito. 
  # GET # PUT para otener o actualizar la orden, deacuerdo al método con que se llama la URL
  PREAPPROVAL = "/preapproval/:id"
  # POST
  CREATE_PREAPPROVAL= "/preapproval"
  
  
  def self.getToken
      mp = MercadoPago.new(Rails.application.secrets.mercadopago_client_id, Rails.application.secrets.mercadopago_client_secret)
      accessToken = mp.get_access_token
  	  return accessToken
  end

end



