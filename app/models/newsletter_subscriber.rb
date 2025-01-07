class NewsletterSubscriber < ActiveRecord::Base
	validates_format_of :email, with: Devise::email_regexp, message: 'Email inválido'

	def unused_email?
		return NewsletterSubscriber.find_by(email: self.email).present?
	end 

	def valid_email?
		regex = /^([0-9]{9})|([A-Za-z0-9._%\+\-]+@[a-z0-9.\-]+\.[a-z]{2,3})$/
		return regex =~ self.email
	end

	def self.download_all_xlsx
		subscribers = NewsletterSubscriber.where(active: true)
		subscribers_sheet = Axlsx::Package.new
		subscribers_sheet.use_autowidth = true
		wb = subscribers_sheet.workbook
		title = wb.styles.add_style(:b=> true, :sz=>12, :buser=> {:style => :thin, :color => "00000000",:edges => [:top,:left, :right, :bottom]})
		wb.add_worksheet(name: "Subscriptores activos") do |sheet|
			headers = ["Email", "Inscrito en"]
			sheet.add_row headers, style: title
			if subscribers.size > 0 	
				subscribers.each do |subscriber|
					row_t = [subscriber.try(:email), subscriber.created_at.strftime("%d/%m/%Y")]
					sheet.add_row row_t
				end				
			end
		end
		return subscribers_sheet
	end

	def self.download_all_csv
		headers = ['email']
		subscribers = NewsletterSubscriber.where(active: true).select(:email)
		CSV.generate(headers: true) do |file|
			file << headers
			subscribers.each do |subscriber|
				file << headers.map{ |header| subscriber.send(header) }
			end
		end
	end
end
