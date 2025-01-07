module Spree
	module Admin
		ProductsController.class_eval do
			before_action :update_stock, only: :stock
			def new
			end

			def edit
				@tags = Tag.all.order('search_count DESC')
				@tag = Tag.new
				respond_with(@object) do |format|
					format.html { render layout: !request.xhr? }
					if request.xhr?
						format.js   { render layout: false }
					end
				end
			end
			def create_tag
				p = Spree::Product.find(params[:product])
				params[:tags].split(",").each do |name| 
					t_name = name.strip
					tag = Tag.find_by(name: t_name)
					if tag.nil?
						tag = Tag.create(name: t_name)
					end
					if params[:check] == '1'
						p.tags << tag
					end
				end
				respond_to do |format|
					format.html { redirect_to :back, notice: 'Se han creado los tags satisfactoriamente.' }
				end			 
			end

			def collection
				return @collection if @collection.present?
				params[:q] ||= {}
				params[:q][:deleted_at_null] ||= "1"
				params[:q][:not_discontinued] ||= "1"
				params[:q][:not_taxon] ||= "1"
		
				params[:q][:s] ||= "name asc"
				@collection = super
				# Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
				# checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
				if params[:q][:deleted_at_null] == '0'
				  @collection = @collection.with_deleted
				end
				# @search needs to be defined as this is passed to search_form_for
				# Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
				# This is to include all products and not just deleted products.
				@search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })

				# Query para buscar todos los productos sin categorizacion
				if params[:q][:not_taxon] == '0'
					@collection = @search.result.
						includes(:taxons).where(taxons: {id: nil}).
						distinct_by_product_ids(params[:q][:s]).
						includes(product_includes).
						page(params[:page]).
						per(params[:per_page] || Spree::Config[:admin_products_per_page])
				else
					@collection = @search.result.
						distinct_by_product_ids(params[:q][:s]).
						includes(product_includes).
						page(params[:page]).
						per(params[:per_page] || Spree::Config[:admin_products_per_page])
				end
				@collection
			end

			def update
				if params[:product][:tags].present?
					tags = Tag.find(params[:product][:tags])
					tags_p = @object.tags.where.not(id: tags)
					tags_p.each do |tag_p|
						@object.tags.delete(tag_p)
					end
					if params[:product][:tags].size != @object.tags.size
						tags.each do |tag|
							unless @object.tags.include? (tag)
								@object.tags << tag
							end	
						end
					end
					params[:product].delete :tags
				else
					@object.tags.delete_all
				end
				if params[:product][:taxon_ids].present?
					params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
				end
				if params[:product][:option_type_ids].present?
					params[:product][:option_type_ids] = params[:product][:option_type_ids].split(',')
				end
				invoke_callbacks(:update, :before)
				offer_price_start = permitted_resource_params.delete(:offer_price_start)
				offer_price_end = permitted_resource_params.delete(:offer_price_end)
				offer_price = permitted_resource_params.delete(:offer_price)
				if offer_price and offer_price != ''
					offer_price = offer_price.to_i
				else
					offer_price = nil
				end
				if @object.update_attributes(permitted_resource_params)
					@object.master.prices[0].update(offer_price: offer_price,
																					offer_price_start: offer_price_start,
																					offer_price_end: offer_price_end)
					invoke_callbacks(:update, :after)
					flash[:success] = flash_message_for(@object, :successfully_updated)
					respond_with(@object) do |format|
						format.html { redirect_to location_after_save }
						format.js   { render layout: false }
					end
				else
				  # Stops people submitting blank slugs, causing errors when they try to
				  # update the product again
				  @product.slug = @product.slug_was if @product.slug.blank?
				  invoke_callbacks(:update, :fails)
				  respond_with(@object)
				end
			end  

			def change_state_of_product				
				respond_to do |format|
					begin
						product = Spree::Product.with_deleted.find(params[:product_id])
						if product.deleted_at
							product.update(deleted_at:nil)
							format.html { redirect_to :back, notice: 'El producto se activo con exito'}
					 	else
							product.update(deleted_at:Time.now)
							format.html { redirect_to :back, notice: 'El producto se desactivo con exito'}
						end
					 rescue Exception => e
					 	format.html { redirect_to :back, alert: 'Ha ocurrido un error al intentar cambiar el estado del producto.'}
					 end
				end
			end

			def documents
				@product = Spree::Product.friendly.find(params[:product_id])
			end

			def delete_documents
				document = TechnicalDocument.find(params[:document_id])
				respond_to do |format|
					begin
						document.document.clear
						if document.destroy
							format.html { redirect_to :back, notice: 'Documento eliminado con éxito.'}
							format.json { render json:  {resp: "Documento eliminado  con éxito."}}
							
						else
							format.html { redirect_to :back, alert: 'Ha ocurrido un error al eliminar el documento.'}
							format.json { render json:  {resp: "Ha ocurrido un error al eliminar el documento."}}	
						end
					rescue Exception => e
						format.html { redirect_to :back, alert: 'Ha ocurrido un error al eliminar el documento.'}
						format.json { render json:  {resp: "Ha ocurrido un error al eliminar el documento."}}
					end
				end
			end 

	    def edit_comparable_attribute
	    	@attribute = ProductComparableAttribute.find_by(id: params[:attribute_id])
	      respond_to do |format|
	        format.js
	      end
	    end

	    def update_comparable_attribute
	    	@attribute = ProductComparableAttribute.find_by(id: params[:attribute_id])
	    	respond_to do |format|
	    		if @attribute and @attribute.update(description: params[:product_comparable_attribute][:description])
		    		format.html{redirect_to admin_product_comparable_attributes_path(params[:id]),
		    								notice: 'Atributo comparable actualizado con éxito'}
					else
						format.html{redirect_to admin_product_comparable_attributes_path(params[:id]),
		    								alert: 'Ocurrió un error al actualizar el atributo comparable'}
		    	end
	    	end
	    end

	    def edit_specific_attribute
	    	@attribute = SpecificAttribute.find_by(id: params[:attribute_id])
	    	@attribute_name = params[:attribute_name]
	    	@attr_type = params[:is_boolean]
	      respond_to do |format|
	        format.js
	      end
	    end

	    def update_specific_attribute
	    	attribute = SpecificAttribute.find_by(id: params[:attribute_id])
	    	attribute_name = params[:attribute_name]
	    	respond_to do |format|
	    		if attribute and attribute.update(attribute_name => params[:specific_attribute][attribute_name])
		    		format.html{redirect_to admin_product_specific_attributes_path(params[:id]),
		    								notice: 'Atributo Miele actualizado con éxito'}
					else
						format.html{redirect_to admin_product_specific_attributes_path(params[:id]),
		    								alert: 'Ocurrió un error al actualizar el atributo Miele'}
		    	end
	    	end
	    end

	    private 

	    def update_stock
	    	Spree::Variant.update_stocks_via_api([@product.master.sku])
	    end
		end
	end
end
