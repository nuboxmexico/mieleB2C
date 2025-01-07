class StoreNoticesController < Spree::BaseController
  include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout '/spree/layouts/admin'
  
  def index
    @store_notices = StoreNotice.all
  end

  def new
    @store_notice = StoreNotice.new
  end

  def create
    @store_notice = StoreNotice.new(store_notice_params)
    respond_to do |format|
      if StoreNotice.count == 0 and @store_notice.save
        format.html{ redirect_to main_app.store_notices_path, notice: 'Aviso creado con éxito'}
      else
        format.html{ redirect_to main_app.new_store_notice_path, alert: 'Ha ocurrido un error. Intente nuevamente'}
      end
    end
  end

  def destroy
    store_notice = StoreNotice.find(params[:id])
    respond_to do |format|
      if store_notice.destroy 
        format.html{ redirect_to main_app.store_notices_path, notice: 'Aviso eliminado con éxito'}
      else
        format.html{ redirect_to main_app.new_store_notice_path, alert: 'Ha ocurrido un error. Intente nuevamente'}
      end
    end
    store_notice.destroy

  end

  private 

    def store_notice_params
      params.require(:store_notice).permit(:content, :link)
    end
end