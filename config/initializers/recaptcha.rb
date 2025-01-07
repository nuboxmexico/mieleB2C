Recaptcha.configure do |config|
  	config.site_key = Rails.application.secrets.public_key_captcha
	config.secret_key = Rails.application.secrets.private_key_captcha
end