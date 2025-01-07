class ComparatorController < Spree::BaseController
	include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout '/spree/layouts/spree_application'
	before_action :check_comp_token, only: [:add_product]
	before_action :set_comparator, only: [:show, :del_product, :download]

	def add_product
		product = Spree::Product.find_by(id: params[:variant_id])
		respond_to do |format|
  		if product
        @comparator.populate(product)
  			format.html{redirect_to '/comparator'}
  		else
  			format.html{redirect_to product_path(variant), alert: 'Ha ocurrido un error'}
  		end
    end
	end
	
	def del_product
		found =  @comparator.items.find_by(spree_variant_id: params[:variant_id])
		respond_to do |format|
			if 	found.delete
				format.js { render 'comparator_details'}
    	
			else
				raise
			end 
    end  

	end

	def show
    @attributes_names = @comparator.attributes_names
	end

  def download
    @attributes_per_page = 4
    total_attributes = @comparator.variants.first.product.comparable_attrs_comparison.size
    @pages = (total_attributes.to_f / @attributes_per_page).ceil
    @attributes_names = @comparator.attributes_names
    respond_to do |format|
      format.pdf do 
        render pdf: 'Comparación Miele', 
               template: 'comparator/download',
               show_as_html: params.key?('debug'),
               margin: {
                top: 0,
                bottom: 0,
                left: 0,
                right: 0
               },
               default_header: false,
               disposition: 'attachment'
      end
    end
  end

	private

		def set_comparator
			unless cookies[:comparator].nil?
				@comparator = Comparator.find_by(comp_token: cookies[:comparator])
			end	
		end
		
		def check_comp_token
			if cookies[:comparator]
				@comparator = Comparator.find_by(comp_token: cookies[:comparator])
				if @comparator.nil?
					@comparator = Comparator.new
					@comparator.comp_token = cookies[:comparator]
					if current_spree_user
						@comparator.spree_user_id = current_spree_user.id
					end
					@comparator.save
				else
					if current_spree_user
						@comparator.spree_user_id = current_spree_user.id
						@comparator.save
					end
				end
			end
		end
end
