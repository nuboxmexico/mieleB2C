module Spree
  HomeController.class_eval do
    before_action :home_banners, only: :index
    
    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @banners = BannerImage.all
      @taxons = Spree::Taxon.all
    end

    def newsletter_popup
      @show_popup = current_store.show_newsletter_popup?(cookies[:newsletter_last_show], 
                                                         spree_current_user)
      if @show_popup
        cookies[:newsletter_last_show] = DateTime.now
      end  
    end

    private 
      def home_banners
        @promotional_banners = []
        @promotional_banners << PromotionalBanner.find_by(active: "Activo", location: 0)
        @promotional_banners << PromotionalBanner.find_by(active: "Activo", location: 1)
        @promotional_banners << PromotionalBanner.find_by(active: "Activo", location: 2)
        @promotional_banners << PromotionalBanner.find_by(active: "Activo", location: 3)
      end

  end
end