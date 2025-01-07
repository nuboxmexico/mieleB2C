class MieleCoreApi 

  def self.find_customer_by_email(customer_email)
    response = api_connection.get do |req|
      req.url '/api/v1/customers/no_id'
      req.body = {
        email: customer_email
      }.to_json
    end

    response = process_response(response)
    if response and response['data']
      return response
    else
      return nil
    end
  end

  def self.create_customer(customer)
    response = api_connection.post do |req|
      req.url '/api/v1/customers'
      req.body = customer.data_to_tickets
                         .to_json
    end

    return process_response(response)
  end

  def self.update_customer(customer, customer_id, purchase_type = nil)
    response = api_connection.patch do |req|
      req.url "/api/v1/customers/#{customer_id}"
      req.body = customer.data_to_tickets(purchase_type)
                         .except(:rut)
                         .to_json
    end

    return process_response(response)
  end

  def self.find_products_by_tnr(product_tnrs)
    response = api_connection.get do |req|
      req.url '/api/v1/products_by_tnr'
      req.body = {
        tnrs: product_tnrs.join(',')
      }.to_json
    end

    return process_response(response)
  end

  def self.assign_product_to_customer(customer_id, product_ids)
    response = api_connection.post do |req|
      req.url "/api/v1/customers/#{customer_id}/create_product"
      req.body = {
        products: product_ids.compact.join(',')
      }.to_json
    end

    return process_response(response)
  end

  def self.get_administrative_demarcations
    response = api_connection.get do |req|
      req.url "/api/v1/administrative_demarcations"
      req.body = {
        keywords: 'CL'
      }.to_json
    end

    return process_response(response)
  end

  def self.add_additional_address_to_customer(customer_id, address_data)
    response = api_connection.post do |req|
      req.url '/api/v1/customersAdditionalAddress'
      req.body = address_data.merge({customer_id: customer_id.to_s}).to_json
    end

    return process_response(response)
  end

  def self.update_customer_additional_address(address_id, address_data)
    response = api_connection.patch do |req|
      req.url "/api/v1/customersAdditionalAddress/#{address_id}"
      req.body = address_data.to_json
    end

    return process_response(response)
  end

  # Request a la api de Miele Core para obtener los Tnr de los productos del core y verificar cuales se encuentran actualmente en el B2C, para poder sincronizarlos 
  def self.getTnrProductsFromMieleCore(country,platform)
    response = api_connection.get do |req|
        req.url '/api/v1/tnr_products_filter_by_country_and_platform'
        req.params['country'] = country
        req.params['platform'] = platform
    end
    
    return process_response(response)
  end

  # Request a la api de Miele Core para obtener data de productos en base a su Tnr
  def self.find_products_by_tnr(product_tnrs)
    response = api_connection.get do |req|
      req.url '/api/v1/products_by_tnr'
      req.body = {
        tnrs: product_tnrs.join(',')
      }.to_json
    end
  
    return process_response(response)
  end

  # Request a la api de Miele core, para obtener el stock de products por TNRs 
  def self.fetch_stock(skus)
    response = api_connection.get do |req|
      req.url "/api/v1/get_stock_of_products"
      req.body = {
        country_iso:"CL",
        tnrs: skus
      }.to_json
      req.options.timeout = 120  
    end
    return process_response(response)
  end

  # Request a la api de Miele core, para obtener el stock de products por TNRs 
  def self.fetch_stock(skus)
    response = api_connection.get do |req|
      req.url "/api/v1/get_stock_of_products"
      req.body = {
        country_iso:"CL",
        tnrs: skus
      }.to_json
      req.options.timeout = 120 
    end
    return process_response(response)
  end

  # Request a la api de Miele core, despues de realizar una venta, para que descuente el stock en base a una lista de productos
  def self.discount_stock_products_on_miele_core(line_items)
    response = api_connection.patch do |req|
      req.url "/api/v1/discount_stock_of_products"
      req.body = {
        country_iso:"CL",
        products: line_items.map{|l| {tnr: l.variant.sku, quantity: l.quantity}}
      }.to_json
    end
    return process_response(response)
  end

  # Request a la api de Miele core, despues de realizar una venta, para que descuente el stock en base a una lista de productos
  def self.discount_stock_products_on_miele_core(line_items)
    response = api_connection.patch do |req|
      req.url "/api/v1/discount_stock_of_products"
      req.body = {
        country_iso:"CL",
        products: line_items.map{|l| {tnr: l.variant.sku, quantity: l.quantity}}
      }.to_json
    end
    return process_response(response)
  end

  # Request a la api de Miele core, despues del fallo de una venta a la altura del proceso de pago, se restaura el valor stock anteriormente descontado a la lista de productos
  def self.restore_stock_products_on_miele_core(line_items)
    response = api_connection.patch do |req|
      req.url "/api/v1/restore_stock_of_products"
      req.body = {
        country_iso:"CL",
        products: line_items.map{|l| {tnr: l.variant.sku, quantity: l.quantity}}
      }.to_json
    end
    return process_response(response)
  end

  private 
    def self.api_connection
      return Faraday.new(
        url: Rails.application.secrets.miele_core_api['url_base'],
        headers: request_headers
      )
    end

    def self.request_headers
      return {
        'Authorization' => "Token token=#{Rails.application.secrets.miele_core_api['token']}",
        'Content-Type' => 'application/json'
      }
    end

    def self.process_response(response)
      if response.status == 200
        return JSON.parse(response.body)
      else
        return nil
      end
    end
end