
module Spree
  class Gateway::WebpayGateway < Gateway
    

    #preference :commerce_id, :string
    #preference :webpay_secret_key, :string
    #preference :client_secret_key, :string
    #preference :subject, :string, default: 'Nueva Compra'

    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def provider
      #Khipu.create_khipu_api(preferred_commerce_id, preferred_khipu_key)
    end

    def self.STATE
      'webpay'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def auto_capture?
      true
    end

    def source_required?
      false
    end

    def supports?(source)
      true
    end

    def provider_class
      ActiveMerchant::Billing::Integrations::Khipu
    end

    def method_type
      'webpay'
    end

    def authorize(money, creditcard, gateway_options)
      provider.authorize(money * 100, creditcard, gateway_options)
    end

    def modify_url_by_payment_type(url)
      return url if not ["manual", "simplified"].include? preferred_payment_type

      url.sub! "/payment/show/", "/payment/#{preferred_payment_type}/"
    end




  end
end
