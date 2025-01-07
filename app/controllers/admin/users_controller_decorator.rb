Spree::Admin::UsersController.class_eval do
	def download_users
		send_data Spree::User.download_all(Spree::User.all).to_stream.read, type: "application/xlsx", filename: "Usuarios_#{Date.today.strftime("%d-%m-%Y")}.xlsx"
	end

	def new_users
		month = Date.today.strftime("%m")
		year = Date.today.strftime("%Y")
		@users = Spree::User.where('extract(month from created_at) = ?',month).where('extract(year from created_at) = ?',year).paginate(page: params[:page], :per_page => 12)
	end

	def download_new_users
		month = Date.today.strftime("%m")
		year = Date.today.strftime("%Y")
		new_users = Spree::User.where('extract(month from created_at) = ?',month).where('extract(year from created_at) = ?',year)
		send_data Spree::User.download_all(new_users).to_stream.read, type: "application/xlsx", filename: "Usuarios_nuevos_#{Date.today.strftime("%d-%m-%Y")}.xlsx"
	end
end