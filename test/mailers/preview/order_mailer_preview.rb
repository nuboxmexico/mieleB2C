class OrderMailerPreview < ActionMailer::Preview
	def confirm_email
		Spree::OrderMailer.confirm_email(Spree::Order.last, false)
	end

	def recover_cart
		Spree::OrderMailer.recovering_cart(Spree::Order.first)
	end
end