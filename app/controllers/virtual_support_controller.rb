class VirtualSupportController < Spree::BaseController
  include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout :check_layout

  before_action :set_virtual_support

  def edit
  end

  def update
    respond_to do |format|
      if @virtual_support.update(virtual_support_params)
        format.html{ redirect_to main_app.virtual_support_path, notice: 'Información de cita virtual editada con éxito' }
      else
        format.html{ redirect_to main_app.virtual_support_path, alert: 'Hubo un problema al actualizar la información' }
      end
    end
  end

  def new
  end

  private
    def virtual_support_params
      params.require(:virtual_support).permit(:url, :description, :active, :background_image, :subtitle, :subdescription)
    end

    def set_virtual_support
      @virtual_support = VirtualSupport.first
    end

    def check_layout
      case action_name
        when 'new'
          '/spree/layouts/spree_application'
        when 'edit'
          '/spree/layouts/admin'
      end
    end
end
