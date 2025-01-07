class ErrorsController < Spree::BaseController
  	include Spree::Core::Engine.routes.url_helpers
		include Spree::Core::Engine.helpers
    include Spree::Core::ControllerHelpers
    include Spree::Core::ControllerHelpers::Order
    include Gaffe::Errors

    skip_before_action :authenticate_user!

    layout 'error'
    def show
      render "errors/#{@rescue_response}", status: @status_code
    end
end


