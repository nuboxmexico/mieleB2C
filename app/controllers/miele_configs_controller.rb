class MieleConfigsController < Spree::BaseController
	include Spree::Core::Engine.routes.url_helpers
	include Spree::Core::Engine.helpers
	include Spree::Core::ControllerHelpers
	include Spree::Core::ControllerHelpers::Order
	layout '/spree/layouts/admin'

	before_action :authenticate_spree_user!
	before_action :set_miele_config, only: :update

	def index
		@config = MieleConfig.last
	end


	def update
		respond_to do |format|
			if @config.update(miele_config_params)
				format.html {redirect_to main_app.miele_configs_path, notice: 'Configuración guardada con éxito.'}
			else
				format.html {redirect_to main_app.miele_configs_path, alert: 'No se ha podido guardar la configuración.'}
			end
		end
	end

	private
	def miele_config_params
		params.require(:miele_config).permit(:title_oportunities, :start_oportunities, :end_oportunities) 
	end

	def set_miele_config
		@config = MieleConfig.last
	end
end