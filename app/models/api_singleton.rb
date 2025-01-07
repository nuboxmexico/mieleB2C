class ApiSingleton < ActiveRecord::Base
	URL_BASE = 'http://www.mocky.io'
  #URL_API = (Rails.env.production? ? 'https://www.mielecustomers.cl' : 'https://miele.garagelabs.cl')
  API_TOKEN = (Rails.env.production? ? "JfHcnEVuKZvjMqHekPYG" : "UDhs2Tz3uS5muVi9zxsg")
  #API_EMAIL = (Rails.env.production? ? "ecommercemiele@garagelabs.cl" : "mieleb2c@garagelabs.cl") 
  URL_API = "http://localhost:4000"
  API_EMAIL = "ecommercemiele@garagelabs.cl"
  API_TOKEN = "JfHcnEVuKZvjMqHekPYG" 
  #API_TOKEN = "UDhs2Tz3uS5muVi9zxsg"
	#'User-Email' : El Email asociado a la tienda en la plataforma 
	#'User-Token' : El token proporcionado por Miele
 	#'ecommerce_sales':
	#[
	#	{
	#		'commune': 'Santiago',
	#		'total': 120391,
	#		'sell_date': '12/03/2020',
	#		'order': 'R9182301',
	#		'products':[
	#			{
	#				'tnr': '7006550',
	#				'quantity': 2,
	#				'total_product': 2000				
	#			},
	#			{
	#				'tnr': '9553030',
	#				'quantity': 4,
	#				'total_product': 39921				
	#			}
	#		]
	#	}
	#]		
 	def self.create_order_api(orders)
    begin
      response = api_connection.post do |req|
      	req.url "/ecommerce_sales.json"
		    req.headers["User-Email"] = Rails.application.secrets.miele_b2b_api['email']
      	req.headers["User-Token"] = Rails.application.secrets.miele_b2b_api['token']
      	req.options.timeout = 120  
        req.body = {
          ecommerce_sales: orders.map{|order| order.to_b2b_api}
        }
		  end
    rescue StandardError => e
      if (e.class == Faraday::ConnectionFailed)
        response = Faraday::Response.new(status: 408, body: "{\"error\": \"Algunas ventas no se han podido escribir.\", \"failed\": #{orders.pluck(:number).try(:to_s)}}")
      else
        response = Faraday::Response.new(status: 500, body: "{\"error\": \"Algunas ventas no se han podido escribir.\", \"failed\": #{orders.pluck(:number).try(:to_s)}}")
      end
    end
    
    if response.status == 500
    	parsed_response = JSON.parse(response.body)
    	if parsed_response['failed']
    		failed_orders = Spree::Order.where(number: parsed_response['failed'])
    		orders_final = orders.where.not(id: failed_orders.pluck(:id))
    		                     .update_all(send_to_api: true)
    	end
    elsif response.status == 200
    	orders.update_all(send_to_api: true)
    end

    return JSON.parse(response.body)
  end

  def self.send_order_to_b2b_for_create_quotation(order)
    response = api_connection.post do |req|
      req.url "/create_ecommerce_quotation"
      req.headers["User-Email"] = Rails.application.secrets.miele_b2b_api['email']
      req.headers["User-Token"] = Rails.application.secrets.miele_b2b_api['token']
      req.options.timeout = 120  
      req.body = {
        ecommerce_sale_order: order.special_data_object_order_for_b2b_quotation
      }
    end

    if response.status == 200
      order.update(send_to_b2b:true)
      order.update(folio_b2b: JSON.parse(response.body)["folio_b2b"])
    end

    return JSON.parse(response.body)
  end

  def self.fetch_stock(skus)
    response = api_connection.get do |req|
      req.url "/get_stock.json"
      req.headers["User-Email"] = Rails.application.secrets.miele_b2b_api['email']
      req.headers["User-Token"] = Rails.application.secrets.miele_b2b_api['token']
      req.options.timeout = 120  
      req.params["tnrs"] = skus
    end

    if response.status == 200
      return JSON.parse(response.body)
    else
      return response.body
    end
  end

  def self.discount_stock(line_items)
    response = api_connection.post do |req|
      req.url "/discount_stock.json"
      req.headers["User-Email"] = Rails.application.secrets.miele_b2b_api['email']
      req.headers["User-Token"] = Rails.application.secrets.miele_b2b_api['token']
      req.body = {
        products: line_items.map{|l| {tnr: l.variant.sku, quantity: l.quantity}}
      }
    end
    if response.status == 200
      return JSON.parse(response.body)
    else
      return false
    end
  end

  def self.reverse_stock(line_items)
    response = api_connection.post do |req|
      req.url "/reverse_stock.json"
      req.headers["User-Email"] = Rails.application.secrets.miele_b2b_api['email']
      req.headers["User-Token"] = Rails.application.secrets.miele_b2b_api['token']
      req.body = {
        products: line_items.map{|l| {tnr: l.variant.sku, quantity: l.quantity}}
      }
    end
    return JSON.parse(response.body)
  end

  private 
    def self.is_invalid_response(response)
      return response.status == 401
    end

    def self.connect_to_api(mock=false)
      if mock
        return Faraday.new(URL_BASE)
      else
        return Faraday.new(Rails.application.secrets.miele_b2b_api['url_base'])
      end
    end

    def self.api_connection
      return self.connect_to_api
    end

    def self.mock_api_connection
      return self.connect_to_api(true)
    end

end
