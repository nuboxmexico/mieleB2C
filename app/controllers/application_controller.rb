class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :products, only: [ :create, :update]
  before_action :offer_price, only: [:update]
  before_action :most_reviews, only: [:index]
  before_action :check_comparator_token
  before_action :newsletter_subscriber
  before_action :check_tag_manager
  before_action :set_store_notice
  before_action :set_taxonomies
  include Spree::AuthenticationHelpers
  include Pagy::Backend
  alias_method  :current_user, :spree_current_user

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    redirect_to root_path, alert: 'Sesión inválida'
  end

  rescue_from ActionView::MissingTemplate do |exception|
    redirect_to root_path, alert: 'La página que buscas no existe.'
  end

  private 

    def set_store_notice
      @store_notice = StoreNotice.first
    end
    
    def newsletter_subscriber
      @newsletter_subscriber = NewsletterSubscriber.new        
    end
    
    def check_comparator_token
      Comparator.create_cookie(cookies)
      @items_comp = 0
      if cookies[:comparator]
        comparator = Comparator.find_by(comp_token: cookies[:comparator])
        if comparator
          @items_comp = comparator.variants.size
        end
      end
    end
    
    def most_reviews
      if controller_name == "home"
        @most_seller = Spree::Product.find(Spree::Product.most_seller_products)
        @recents = Spree::Product.all.order(created_at: :desc).limit(4)
        @last_offers = Spree::Product.all.order(updated_at: :desc)
            .reject { |p| p.master.prices[0].try(:offer_price) || check_offer(p)}
        if @last_offers.size > 4
          @last_offers = @last_offers[0,4]
        end
        @most_reviews =  Spree::Product.where{reviews_count > 0}.order(reviews_count: :desc).limit(4)
        @featured = Spree::Product.featured.order(updated_at: :desc)
        @featured_categories = Spree::Taxon.where(featured: :true).order(updated_at: :desc)
      end
    end

    def check_offer(product)
      if product.master.prices[0].try(:offer_price)
        if product.master.prices[0].offer_price < 1
          return true
        end
      end
      return false 
    end

		def products
			if controller_name == "products"
				sku = params[:product][:sku]
				if !sku.nil?
          @product.master.sku = sku
				  @product.master.save
				  @product.sku = sku
				  @product.save
			  end 
      end
		end
		def offer_price
      if controller_name == "products"
        if params[:product][:sku]
          v = Spree::Variant.find_by(sku: params[:product][:sku])
        else
          v = Spree::Product.find(params[:product_id]).master
        end
        if v
          v.prices[0].offer_price = params[:product][:offer_price].to_d
          v.prices[0].save
        end
      end
		end
    def check_tag_manager
      tag_manager = TagManager.first
      unless tag_manager.nil? 
        @tag_manager = tag_manager
      end
    end

    def set_taxonomies
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end



    def installation_value
      if @installation_value.nil?
        @installation_value = calculate_installation_value(@order)
      else
        @installation_value
      end
    end

    def calculate_installation_value(order)
        @order.update_column(:instalation, false)
        shipping_region = order.try(:ship_address).try(:state)
        with_instalation = order.line_items.select{|l| l.instalation}
                                 .map{|l| l.quantity}
                                 .reduce(:+)                 
        case with_instalation
        when 1
          return shipping_region.try(:inst_a).to_i * with_instalation
        when 2..5
          return shipping_region.try(:inst_b).to_i * with_instalation
        when 6..Float::INFINITY
          return shipping_region.try(:inst_c).to_i * with_instalation
        else
          return 0
        end                                   
    end
    protected

		# Authenticate the user with token based authentication
		def authenticate
			#return if Rails.env.test?
			authenticate_token || render_unauthorized
		end

		def authenticate_token
			if current_user.nil?	
        
        authenticate_with_http_token do |token, options|
          @current_user = Spree::User.find_by(api_key: token)
        end

      else
				current_user
			end
		end

		def render_unauthorized(realm = "Application")
			self.headers["WWW-Authenticate"] = %(Token realm="#{realm}")
			render json: {"error": "Ingreso no autorizado"}, status: :unauthorized
		end
end

