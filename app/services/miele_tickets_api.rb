class MieleTicketsApi 
  def self.find_customer_by_email(customer_email)
    response = api_connection.get do |req|
      req.url '/api/v1/customers/no_id'
      req.body = {
        email: customer_email
      }.to_json
    end

    return process_response(response)
  end

  def self.create_customer(customer, country_id = 'CL')
    response = api_connection.post do |req|
      req.url '/api/v1/customers'
      req.body = customer.data_to_tickets
                         .merge({country: country_id})
                         .to_json
    end

    return process_response(response)
  end

  def self.update_customer(customer, customer_id, country_id = 'CL')
    response = api_connection.patch do |req|
      req.url "/api/v1/customers/#{customer_id}"
      req.body = customer.data_to_tickets
                         .merge({country: country_id})
                         .except(:rut)
                         .to_json
    end

    return process_response(response)
  end

  private 
    def self.api_connection
      return Faraday.new(
        url: Rails.application.secrets.miele_tickets_api['url_base'],
        headers: request_headers
      )
    end

    def self.request_headers
      return {
        'Authorization' => "Token token=#{Rails.application.secrets.miele_tickets_api['token']}",
        'Content-Type' => 'application/json'
      }
    end

    def self.process_response(response)
      if response.status == 200
        return JSON.parse(response.body)
      else
        a = File.new("a.json",'a')
        a.write(JSON.parse(response.body))
        a.write("\n\n\n\n")
        a.close()
        return nil
      end
    end
end