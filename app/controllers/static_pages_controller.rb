class StaticPagesController < Spree::BaseController
  include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout '/spree/layouts/admin', except: [:show]

  before_action :set_static_page, only: [:edit, :update, :destroy]
  before_action :authenticate_spree_user!, except: [:show]

  def index
    @footer_pages = StaticPage.where(editable: false).order(id: :asc)
    @blog_pages = StaticPage.where(editable: true)
  end

  def new
    @static_page = StaticPage.new(editable: true)
    @url = '/static_pages'
  end

  def create
    @static_page = StaticPage.new(static_page_params)
    # @static_page.url = @static_page.name[0..50].join('-')
    @static_page.editable = true
    respond_to do |format|
      if @static_page.save
        format.html{redirect_to main_app.static_pages_path, notice: 'Página creada con éxito'}
      else
        format.html{redirect_to main_app.new_static_page_path, alert: 'Ha ocurrido un error. Por favor intente nuevamente'}
      end
    end
  end

  def edit
    @url = main_app.static_page_path(@static_page)
  end

  def update
    data =  static_page_params
    if params[:default_bg_image] == '1'
      @static_page.background_image.destroy
      @static_page.save
    end
    respond_to do |format|
      if @static_page.update(data)
        format.html{redirect_to main_app.static_pages_path, notice: 'Página estática editada con éxito'}
      else
        format.html{redirect_to main_app.edit_static_page_path(@static_page), alert: 'Ha ocurrico un error. Intente nuevamente'}
      end
    end
  end

  def show
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    @static_page = StaticPage.find_by(slug: params[:slug])

    @title = @static_page&.name
    render layout: '/spree/layouts/spree_application'
  end

  def destroy
    @static_page.destroy
    respond_to do |format|
      format.js { render :js=> "location.reload();" }
    end
  end

  private
    def set_static_page
      @static_page = StaticPage.find_by(slug: params[:id])
    end

    def static_page_params
      params.require(:static_page).permit(:content, :name, :background_image, :default_bg_image)
    end
end
