Spree::Payment.class_eval do
  scope :from_webpay, -> { joins(:payment_method).where(spree_payment_methods: {type: Spree::Gateway::WebpayGateway.to_s}) }
  scope :from_khipu, -> { joins(:payment_method).where(spree_payment_methods: {type: Spree::Gateway::KhipuGateway.to_s}) }
end

