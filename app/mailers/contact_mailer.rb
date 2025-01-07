class ContactMailer < Spree::BaseMailer
	default from: "#{Rails.application.secrets.mail_admin}"
	def send_contact_to_section(message)
		@message = message
		to = Rails.application.secrets.contact_mails
		mail( :to => to, :subject => 'Nuevo formulario de contacto para ti')
	end
end