class LocalUserController < ActionController::Base

	def update
		address = Spree::Address.new
		address.firstname = params[:address][:firstname]
		address.lastname = params[:address][:lastname]
		address.address1 = params[:address][:address1]
		address.number = params[:address][:number]
		address.apartment = params[:address][:apartment]
		address.address2 = params[:address][:address2]
		address.city = params[:address][:city]
		address.zipcode = params[:address][:zipcode]
		address.phone = params[:address][:phone]
		address.state_id = params[:address][:state_id]
		address.country_id = params[:address][:country_id]
		address.comuna_id = params[:address][:comuna_id]
		address.street_type = params[:address][:street_type]
		address.save!
		if params[:address][:type] == 'ship'
			current_spree_user.ship_address_id = address.id
		elsif params[:address][:type] == 'bill'
			current_spree_user.bill_address_id = address.id
		end	
		current_spree_user.save!
		respond_to do |format|
          format.html { redirect_to :back, notice: 'Se ha registrado la dirección correctamente'}
        end
	end
end