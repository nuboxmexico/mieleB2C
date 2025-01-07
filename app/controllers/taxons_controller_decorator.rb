module Spree
  TaxonsController.class_eval do
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found_404
  	def get_taxon
    	begin
    		@taxon = Taxon.friendly.find(params[:id])
    	rescue
    		@taxon = nil
    	end
    	respond_to do |format|
        	format.json {render json: @taxon}
      	end
    end
    def show
      @promotional_banner = PromotionalBanner.find_by(location: 4, active: 'Activo')
      @taxon = Taxon.friendly.find(params[:id])  
      return unless @taxon

      #@searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @pagy, @products = pagy(@taxon.products.not_discontinued.order(name: :asc))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    private
      def render_not_found_404
        render layout: "error", template: 'errors/not_found', :status => '404'
      end
  end
end
