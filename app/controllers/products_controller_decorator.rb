module Spree
  ProductsController.class_eval do
    include ActionView::Helpers::NumberHelper

    before_action :increase_viewed, only: [:show]
    before_action :get_taxonomy, only: [:show, :oportunities]
    respond_to :rss, :only => [:index]

    def most_selled
      @most_selled = Spree::Product.find(Spree::Product.most_seller_products)
    end

    def recents
      @recents = Spree::Product.all.order(created_at: :desc).limit(20)
    end
    def get_taxonomy
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def rss
      @products = Spree::Product.includes(:variants, :variant_images, :master)
                                .where.not(available_on: nil)
      @products = @products.available
      @products = @products.limit(10) if !Rails.env.production?
      respond_to do |format|
        format.xml
      end
    end

    def index
      respond_to do |format|
        format.html{
          @taxonomies = Spree::Taxonomy.includes(root: :children)
          @searcher = build_searcher(params.merge(include_images: true))
          @products = @searcher.retrieve_products
        }
        format.js
        format.json {
          if !params[:keywords].nil?
            
            @searcher = build_searcher(params.merge(include_images: true))
            @products = @searcher.retrieve_products
            if(params[:keywords].size > 0)
              if params[:brand_any] != ""
                brands_p = params[:brand_any].split(",")
                @products = @products.joins(:product_properties).where(product_properties:{value: brands_p })
                r = Spree::Product.where("sensitive_name ~* ?", params[:keywords].downcase.mb_chars.normalize(:kd).gsub(/[^x00-\x7F]/n, '').to_s).joins(:taxons).where(taxons: { id: params[:taxon]}).joins(:product_properties).where(product_properties:{value: brands_p })
                t = Spree::Product.joins(:tags).where("tags.name ~* ?", params[:keywords].downcase).joins(:product_properties).where(product_properties:{value: brands_p }).distinct
              else
                r = Spree::Product.where("sensitive_name ~* ?", params[:keywords].downcase.mb_chars.normalize(:kd).gsub(/[^x00-\x7F]/n, '').to_s).joins(:taxons).where(taxons: { id: params[:taxon]})
                t = Spree::Product.joins(:tags).where("tags.name ~* ?", params[:keywords].downcase).distinct
              end
              @products = @products.where.not(id: [*r.pluck(:id),*t.pluck(:id) ])
              @products = [*t,*@products, *r]
            else
              if params[:brand_any]
                if params[:brand_any] != ""
                  brands_p = params[:brand_any].split(",")
                  @products = @products.joins(:product_properties).where(product_properties:{value: brands_p })
                end
              end
            end

            if(params["order_criteria"] == "1" )#Mayor precio
              @products = (@products.sort_by {|product| product.real_price }).reverse
            elsif(params["order_criteria"] == "2" )#Mayor descuento
              @products = (@products.sort_by {|product| product.discount_percentage }).reverse
            elsif(params["order_criteria"] == "3" )#Menor precio
              @products = (@products.sort_by {|product| product.real_price })
            elsif(params["order_criteria"] == "4" )#Menor descuento
              @products = (@products.sort_by {|product| product.discount_percentage })
            elsif(params["order_criteria"] == "5" )#A -- Z
              @products = (@products.sort_by {|product| product.name })
            elsif(params["order_criteria"] == "6" )#Z -- A
              @products = (@products.sort_by {|product| product.name }).reverse
            end

          else
            @products = Spree::Product.all
            if(params["order_criteria"] == "1" )#Mayor precio
              @products = (@products.sort_by {|product| product.real_price }).reverse
            elsif(params["order_criteria"] == "2" )#Mayor descuento
              @products = (@products.sort_by {|product| product.discount_percentage }).reverse
            elsif(params["order_criteria"] == "3" )#Menor precio
              @products = (@products.sort_by {|product| product.real_price })
            elsif(params["order_criteria"] == "4" )#Menor descuento
              @products = (@products.sort_by {|product| product.discount_percentage })
            elsif(params["order_criteria"] == "5" )#A -- Z
              @products = (@products.sort_by {|product| product.name })
            elsif(params["order_criteria"] == "6" )#Z -- A
              @products = (@products.sort_by {|product| product.name }).reverse
            end
            @products = @products.paginate(page: params[:page], :per_page => 12)
          end
          #@products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
          @taxonomies = Spree::Taxonomy.includes(root: :children)
          #n%Spree::Config.products_per_page != 0 ? n/Spree::Config.products_per_page+1 : n/Spree::Config.products_per_page

          ## Tratamiento de los datos para servicio de react
          if params[:taxonomies]
            @obj = @taxonomies.to_json(:include => {:root => {:include => {:children => {:include => {:children => {:methods => [:friendly_id]}},:methods => [:friendly_id]} } ,:methods => [:friendly_id] }})
          else
            obj_t = @products.to_json(:include => [ {:master => {:include => [{:images => {:methods => [:large_url, :mini_url]} }, :prices]}}, {:variants => {:include => :option_values}} ], :methods => [:price, :can_supply])
            @obj = {}
            @obj["products"] = obj_t
            unless @products.try(:total_entries).nil?
              n = @products.total_entries.to_i
              @obj["total_pages"] = (n%Spree::Config.products_per_page != 0 ? n/Spree::Config.products_per_page+1 : n/Spree::Config.products_per_page)
            else
              @obj["total_pages"] = 0
            end
            unless @products.try(:current_page).nil?
              @obj["current_page"] = @products.current_page
            else
              @obj["current_page"] = 1
            end
          end
          @obj['total_items'] = @products.count
          render json: @obj
        }
        format.rss{
          @products = Spree::Product.all
        }
        format.xml{
          @products = Spree::Product.all
        }
      end
    end
    def properties
      product = Spree::Product.find(params[:product_id])
      params[:product][:product_properties_attributes].each do |prop|
        if prop[1]["property_name"] != ""
          if prop[1].key?("id")
            begin
              property = Spree::Property.find(prop[1]["property_name"])
            rescue
              property = nil
            end
            unless property.nil?
              prop_include = product.properties.include? property
              if !prop_include
                raise prop_include.to_yaml
                product_property = Spree::ProductProperty.new
                product_property.value = prop[1]["value"]
                product_property.property_id = property.id
                product_property.save!
                product.product_properties << product_property
              else
                product_property = Spree::ProductProperty.where(product_id: product.id, property_id: property.id).take
                product_property.value = prop[1]["value"]
                product_property.property_id = property.id
                product_property.save!
              end
            end
          else
            property = Spree::Property.where(name: prop[1]["property_name"]).try(:first)
            if property.nil?
              property = Spree::Property.new
              property.name = prop[1]["property_name"]
              property.presentation = prop[1]["property_name"]
              property.save!
            end
            prop_include = product.properties.include? property
            if !prop_include
              product_property = Spree::ProductProperty.new
              product_property.value = prop[1]["value"]
              product_property.property_id = property.id
              product_property.save!
              product.product_properties << product_property
            end
          end
        end
      end
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Se han agregado las propiedades satisfactoriamente.' }
      end
    end
    def brands
      brand_property = Spree::Property.find_by(name: 'brand')
      brands = brand_property ? Spree::ProductProperty.where(property_id: brand_property.id).pluck(:value).uniq.map(&:to_s) : []
      respond_to do |format|
        format.html
        format.js
        format.json {render json: brands.to_json}
      end
    end

    def comparable_attributes
    end

    def specific_attributes
    end

    def oportunities
      @title = "Oportunidades "
      respond_to do |format|
        format.html
        format.js {
          @products = Spree::Product.all.select{|p| p.offer_price_available? and p.available?}
        }
      end
    end

    def fetch_stock
      render json: Spree::Variant.update_stocks_via_api(params[:tnrs])
    end

    # GET /products/:slug/list_prices
    def list_prices
      @product = Spree::Product.find_by_slug(params[:id])
      if @product.offer_price_available?
        @offer_price = @product.master.prices.first.offer_price
      end
      respond_to do |format|
        format.js
      end
    end

    private
      def increase_viewed
        @product.update_column(:viewed_count, (@product.viewed_count + 1))
      end
  end
end
