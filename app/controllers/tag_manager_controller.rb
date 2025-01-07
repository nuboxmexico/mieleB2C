class TagManagerController < Spree::Admin::BaseController
	include Spree::Core::Engine.routes.url_helpers
    include Spree::Core::Engine.helpers
    include Spree::Core::ControllerHelpers
    include Spree::AuthenticationHelpers
	helper 'spree/admin/navigation'
    layout '/spree/layouts/admin'

	def index
		@tag_manager = TagManager.first
		if @tag_manager.nil?
			@tag_manager = TagManager.new
		end
	end
	def update
		tag_manager = TagManager.first
		if tag_manager.nil?
			tag_manager = TagManager.new
		end
		tag_manager.tag_manager_id =  params[:tag_manager_id].to_s
		tag_manager.active =  !params[:active].nil? ? true : false
		respond_to do |format|
	      if tag_manager.save
	        format.html { redirect_to :back, notice: 'Se han registrado su llave de Tag Manager satisfactoriamente.' }
	        format.json { render :show, status: :created, location: tag_manager }
	      else
	        format.html { render :back, notice: 'Ha ocurrido un error.' }
	        format.json { render json: tag_manager.errors, status: :unprocessable_entity }
	      end
	    end
	end
end
