class PromotionalBannersController < Spree::BaseController
  include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout '/spree/layouts/admin'

  before_action :authenticate_spree_user!
  before_action :set_promotional_baner, only: [:edit, :update]
  
  def index
    @promotional_banners = PromotionalBanner.where.not(location: 6)
  end

  def new
    @promotional_banner = PromotionalBanner.new
  end

  def create
    @promotional_banner = PromotionalBanner.new(promotional_banner_params)
    respond_to do |format|
      if @promotional_banner.save
        if @promotional_banner.taxon
          format.html{ redirect_to main_app.categories_banners_path, notice: 'Banner creado con éxito'}
        else
          format.html{ redirect_to main_app.promotional_banners_path, notice: 'Banner creado con éxito'}
        end
      else
        raise @promotional_banner.errors.inspect
        format.html{ redirect_to :back, alert: 'Ha ocurrido un error. Intente nuevamente'}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @promotional_banner.update(promotional_banner_params)
        format.html{ redirect_to main_app.promotional_banners_path}
      else
        format.html{ redirect_to :back, alert: 'Ha ocurrido un error. Intente nuevamente'}
      end
    end
  end

  def categories
    @taxons = Spree::Taxon.all.includes(:banner)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def categories_add_banner
    @taxon = Spree::Taxon.find_by(id: params[:taxon_id])
    if @taxon and @taxon.banner
      @taxon.banner.destroy
    end
    @promotional_banner = PromotionalBanner.new
  end

  private 

    def promotional_banner_params
      data = params.require(:promotional_banner)
                 .permit(:title, :link, :alt, :location, 
                         :image, :active, :mobile_image)

      taxon = Spree::Taxon.find_by(id: params[:promotional_banner][:taxon_id])
      return data.merge({taxon: taxon})
    end

    def set_promotional_baner
      @promotional_banner = PromotionalBanner.find(params[:id])
    end
end
