class FbpixelController < Spree::Admin::BaseController
	# include Spree::Core::Engine.routes.url_helpers
    # include Spree::Core::Engine.helpers
    # include Spree::Core::ControllerHelpers
    # include Spree::AuthenticationHelpers
	# helper 'spree/admin/navigation'
    # layout '/spree/layouts/admin'

	# def index
	# 	@fbpixel = Fbpixel.first
	# 	if @fbpixel.nil?
	# 		@fbpixel = Fbpixel.new
	# 	end
	# end
	# def update
	# 	fbpixel = Fbpixel.first
	# 	if fbpixel.nil?
	# 		fbpixel = Fbpixel.new
	# 	end
	# 	fbpixel.pixel_id =  params[:pixel_id].to_s
	# 	fbpixel.active =  !params[:active].nil? ? true : false
	# 	fbpixel.search =  !params[:search].nil? ? true : false
	# 	fbpixel.view_content =  !params[:view_content].nil? ? true : false
	# 	fbpixel.add_to_cart =  !params[:add_to_cart].nil? ? true : false
	# 	fbpixel.initiate_checkout =  !params[:initiate_checkout].nil? ? true : false
	# 	fbpixel.add_payment_info =  !params[:add_payment_info].nil? ? true : false
	# 	fbpixel.purchase =  !params[:purchase].nil? ? true : false
	# 	fbpixel.lead_client =  !params[:lead_client].nil? ? true : false
	# 	fbpixel.complete_registration =  !params[:complete_registration].nil? ? true : false
	# 	respond_to do |format|
	#       if fbpixel.save
	#         format.html { redirect_to :back, notice: 'Se han registrado sus datos del Pixel satisfactoriamente.' }
	#         format.json { render :show, status: :created, location: fbpixel }
	#       else
	#         format.html { render :back, notice: 'Ha ocurrido un error.' }
	#         format.json { render json: fbpixel.errors, status: :unprocessable_entity }
	#       end
	#     end
	# end
end
