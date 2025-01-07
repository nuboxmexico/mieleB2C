Spree::User.class_eval do

	validates :rut, uniqueness: true
	has_many :comparators, foreign_key: 'spree_user_id'

	def comparator
		return self.comparators.first
	end

	def self.download_all(users)
		user_sheet = Axlsx::Package.new
		user_sheet.use_autowidth = true
		wb = user_sheet.workbook
		title = wb.styles.add_style(:b=> true, :sz=>12, :buser=> {:style => :thin, :color => "00000000",:edges => [:top,:left, :right, :bottom]})
		wb.add_worksheet(name: "Facturacion") do |sheet|
			headers = ["Email", "Nombre completo", "Rut", "Teléfono", "Fecha creación", "Dirección", "Comuna", "Región", "Total compras"]
			sheet.add_row headers, style: title
			if users.size > 0 	
				users.each do |user|
					address = nil
					if user.ship_address
						address = user.ship_address
					elsif user.bill_address
						address = user.bill_address
					elsif user.orders.size > 0
						address = user.orders.last
					end
					if user.orders.size > 0
						purchase_total = user.orders.sum(:total)
					else 
						purchase_total = 0
					end
					row_t = [user.try(:email), user.try(:name).to_s + ' ' + user.try(:last_name).to_s, user.try(:rut), (user.try(:phone) ? '+56'+user.try(:phone).to_s : 'No registrado'), user.created_at.strftime("%d/%m/%Y"), (address ? address.try(:address1) : 'No registrado'), (address ? address.try(:comuna).try(:name) : 'No registrado'), (address ? address.try(:state).try(:name) : 'No registrado'), purchase_total]
					sheet.add_row row_t
				end				
			end
		end
		return user_sheet
	end

	def full_name
		return "#{self.name} #{self.last_name}"
	end

	def newsletter_subscriber?
		return NewsletterSubscriber.find_by(email: self.email).present?
	end

	def data_to_tickets(purchase_type = nil)
		personal_data = {
			names: self.name,
			lastname: self.last_name,
			email: self.email,
			rut: self.rut,
			country_id: 'CL'
		}

		if self.ship_address
			personal_data.merge!(self.ship_address
															 .data_to_core)
		end

		if purchase_type
			personal_data.merge!(self.billing_data(purchase_type))
		end

		return personal_data
	end

	def billing_data(purchase_type)
		case purchase_type
		when 'bill'
			return nil # Add hash with data for bill
		when 'ticket'
			return self.ship_address
								 .billing_data
								 .merge({
										business_name: self.full_name,
										rfc: self.rut,
										commercial_business: 'persona natural',
										email_fn: self.email,
									})
		else
			return nil
		end
			
	end

	def create_or_update_on_core(purchase_type = nil)
		customer_data = MieleCoreApi.find_customer_by_email(self.email)

		if customer_data
			return MieleCoreApi.update_customer(self, customer_data['data']['id'], purchase_type)
		else
			return MieleCoreApi.create_customer(self)
		end
	end

	def save_addresses(order)
		new_ship_address = order.ship_address.dup
		new_bill_address = order.bill_address.dup

		self.update(ship_address: new_ship_address, bill_address: new_bill_address)
	end
	
	def generate_api_key
		token = ""
		loop do
		  token = SecureRandom.base64.tr('+/=', 'Qrt')
		  break token unless User.exists?(api_key: token)
		end
		self.update(api_key: token)
	end
end