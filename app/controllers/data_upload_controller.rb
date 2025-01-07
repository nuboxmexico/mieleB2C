class DataUploadController < Spree::Admin::BaseController
	include Spree::Core::Engine.routes.url_helpers
	include Spree::Core::Engine.helpers
	include Spree::Core::ControllerHelpers
	include Spree::AuthenticationHelpers
	helper 'spree/admin/navigation'
	layout '/spree/layouts/admin'
	require 'roo'
	require 'fastimage'

	def upload_data
	end
	def uploadBanner
		@banner = BannerImage.new
		@banners = BannerImage.all
	end
	def upload_banner_image
		@banner = BannerImage.new
		begin
			d_t = FastImage.size(params[:banner_image][:image].path)
			@banner.widht = d_t[0]
			@banner.height = d_t[1]
			@banner.alt = params[:banner_image][:alt]
			@banner.image = params[:banner_image][:image]	
			@banner.save
			redirect_to request.env["HTTP_REFERER"], notice: 'Imagen subida con éxito.'
		rescue Exception => e
			redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error al cargar la imagen'
		end
	end

	def delete_banner_image
		@banner = BannerImage.find(params[:banner_id])
		respond_to do |format|
			begin
				@banner.image.clear
				if @banner.destroy
					format.html { redirect_to request.env["HTTP_REFERER"], notice: 'Imagen eliminada con éxito.'}
					format.json { render json:  {resp: "Imagen eliminada con éxito."}}
					
				else
					format.html { redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error al eliminar la imagen'}
					format.json { render json:  {resp: "Ha ocurrido un error al eliminar la imagen"}}	
				end
			rescue Exception => e
				format.html { redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error al eliminar la imagen'}
				format.json { render json:  {resp: "Ha ocurrido un error al eliminar la imagen"}}
			end
		end
	end

	def assign_image
		if current_spree_user.admin?
			begin
				find_b = BannerImage.find_by(element_id: params["element-id"])
				if params["image-select"] and params["image-select"] != ''
					if find_b
						find_b.element_id = nil
						temp_text = find_b.title_text 
						find_b.title_text = nil
						find_b.save
						find_b = BannerImage.find(params["image-select"])
						find_b.element_id = params["element-id"].to_s
						find_b.title_text = temp_text
						find_b.save
					else
						find_b = BannerImage.find(params["image-select"])
						find_b.element_id = params["element-id"].to_s
						find_b.save
					end
				end
				if (params["element-id"].include? "category")
					unless params["taxon"] == ""
						taxon = Spree::Taxon.find_by(category_home_id: params["element-id"])
						unless taxon.nil?
							taxon.category_home_id = nil
							taxon.save
						end
						taxon = Spree::Taxon.find(params["taxon"])
						taxon.category_home_id = params["element-id"]
						taxon.save
					end
				end
				if (params["element-id"].include? "banner")
					if find_b
						find_b.title_text = params["banner-title"]	
						if params["link"].present?
							find_b.link = params["link"]
							find_b.link_button = params["add_button"] == 'Si' ? true : false
						else
							find_b.link = ""
							find_b.link_button = false
						end	 
						find_b.save
					end
				end
				redirect_to request.env["HTTP_REFERER"], notice: 'Imagen cambiada con éxito.'
			rescue Exception => e
				redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error al cargar la imagen'
			end
		else
			redirect_to request.env["HTTP_REFERER"], alert: 'Usted no tiene permisos para realizar esta acción'
		end
	end	
	
	def import_categories
		success, session[:errors] = DataUpload.upload_categories(params[:file])
		respond_to do |format|
			if success
				format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Categorías cargadas con éxito.'}
			else
				format.html{redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un problema al cargar las categorías.'}
			end
		end
	end
	
	def import_products
		success, session[:errors] = DataUpload.upload_products(params[:file])
		respond_to do |format|
			if success and session[:errors].empty?
				format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Productos cargados con éxito.'}
			else
				format.html{redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un problema al cargar los productos.'}
			end
		end
	end

	def import_images
		DataUpload.upload_images(params[:file])
		respond_to do |format|
			format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Imágenes cargadas con éxito.'}
		end
	end
	## HACER MOVIMIENTOS DE STOCK 
	def import_stock
		success, session[:errors] = DataUpload.update_stock(params[:file])
		respond_to do |format|
			if success and session[:errors].empty?
				format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Stock de productos cargados con éxito.'}
			else
				format.html{redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un problema al cargar los stock de productos.'}
			end
		end
	end

	def download_stock
		@stocks = Spree::Variant.update_stocks_via_api(Spree::Variant.all.pluck(:sku))
		@products = Spree::Variant.all
		respond_to do |format|
			format.xlsx{render xlsx: 'download_stock', filename: "plantilla_stock_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
	end

	def download_products
		@variants = Spree::Variant.all
		respond_to do |format|
			format.xlsx{render xlsx: 'download_products', filename: "plantilla_productos_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
	end

	def download_products_metadata
		@variants = Spree::Variant.all
		respond_to do |format|
			format.xlsx{render xlsx: 'download_products_metadata', filename: "plantilla_metadata_productos_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
	end

	def download_categories_metadata
		@taxons = Spree::Taxon.all
		respond_to do |format|
			format.xlsx{render xlsx: 'download_categories_metadata', filename: "plantilla_metadata_categorias_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end	
	end

	def download_offer_prices
		@offer_prices = Spree::Price.where.not(offer_price: nil)
		respond_to do |format|
			format.xlsx{render xlsx: 'download_offer_prices', filename: "plantilla_precios_oferta_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
	end

	def download_related_products
		@products = Spree::Product.all
		respond_to do |format|
			format.xlsx{render xlsx: 'download_related_products', filename: "plantilla_productos_relacionados_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
	end

	def import_tech_documents
		DataUpload.upload_technical_files(params[:file])
		respond_to do |format|
			format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Documentos cargados con éxito.'}
		end
	end

	def download_categories_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_categorias.xlsx",
			filename: "plantilla_categorias.xlsx",
			type: "application/xlsx"
			)
	end

	def download_products_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_productos.xlsx",
			filename: "plantilla_productos.xlsx",
			type: "application/xlsx"
			)
	end

	def download_stock_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_stock.xlsx",
			filename: "plantilla_stock.xlsx",
			type: "application/xlsx"
			)
	end

	def download_related_products_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_productos_relacionados.xlsx",
			filename: "plantilla_productos_relacionados.xlsx",
			type: "application/xlsx"
		)
	end

	def download_offer_prices_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_precios_oferta.xlsx",
			filename: "plantilla_precios_oferta.xlsx",
			type: "application/xlsx"
		)
	end

	def download_products_metadata_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_metadata_productos.xlsx",
			filename: "plantilla_metadata_productos.xlsx",
			type: "application/xlsx"
			)
	end

	def download_categories_metadata_template
		send_file(
			"#{Rails.root}/public/resources/plantilla_metadata_categorias.xlsx",
			filename: "plantilla_metadata_categorias.xlsx",
			type: "application/xlsx"
			)
	end

	def import_products_metadata
		success, session[:errors] = DataUpload.upload_products_metadata(params[:file])
		respond_to do |format|
			if success
				format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Metadata de productos cargada con éxito.'}
			else
				format.html{redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un problema al cargar la metadata de productos.'}
			end
		end	
	end

	def import_categories_metadata
		success, session[:errors] = DataUpload.upload_categories_metadata(params[:file])
		respond_to do |format|
			if success
				format.html{redirect_to request.env["HTTP_REFERER"], notice: 'Metadata de categorías cargada con éxito.'}
			else
				format.html{redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un problema al cargar la metadata categorías.'}
			end
		end	
	end

	def import_related_products
		success, session[:errors] = DataUpload.upload_related_products(params[:file])
		respond_to do |format|
			if success && session[:errors].empty?
				format.html {redirect_to request.env["HTTP_REFERER"], notice: 'Productos relacionados cargados con éxito'}
			else
				format.html {redirect_to request.env["HTTP_REFERER"], error: 'Ha ocurrido un error al intentar cargar el archivo'}
			end
		end
	end

	def import_comparable_attributes
		respond_to do |format|
			if DataUpload.comparable_attributes(params[:file])
				format.html {redirect_to request.env["HTTP_REFERER"], notice: 'Atributos comparables cargados con éxito'}
			else
				format.html {redirect_to request.env["HTTP_REFERER"], error: 'Ha ocurrido un error al intentar cargar el archivo'}
			end
		end
	end

	def import_offer_prices
		success, session[:errors] = DataUpload.upload_offer_prices(params[:file])
		respond_to do |format|
			if success && session[:errors].empty?
				format.html {redirect_to request.env["HTTP_REFERER"], notice: 'Precios de oferta cargados con éxito'}
			else
				format.html {redirect_to request.env["HTTP_REFERER"], error: 'Ha ocurrido un error al intentar cargar el archivo'}
			end
		end
	end
	
	# Metodo que sincroniza la data de los productos provenientes de miele core, que se encuentran definidos para B2C
	def synchronize_products_with_miele_core
		response = RequestDataMieleCore.synchronizeNewProductsWithMieleCore
		if response[:status]==400
			render :json => response
		elsif response[:status]==200
			second_response = RequestDataMieleCore.synchronizeCreatedProductsWithMieleCore
			if second_response[:status]==400
				render :json => second_response	
			elsif second_response[:status]==200
				respond_to do |format|
					format.html {redirect_to request.env["HTTP_REFERER"], notice: second_response[:message]}
				end
			end		
		end
	end

	# Metodo para reenviar los ordenes que no se lograron mandar para el b2b
	def resend_orders_to_b2b
		errors=[]
		success = true

		begin 
			pending_orders = Spree::Order.where(payment_state: "paid", send_to_api: false).where.not(completed_at: nil)
			response = ApiSingleton.create_order_api(pending_orders)
			
			orders = Spree::Order.where(send_to_b2b:false)
			orders.each do |order| 
				response = ApiSingleton.send_order_to_b2b_for_create_quotation(order)

				if response["created"] == "fail"
					errors.push(response)
				end
			end

			success = false if !errors.empty?

		rescue Exception => e
			success = false
			errors.push(e.to_s)
		end

		respond_to do |format|
			if success && errors.empty?
				format.html {redirect_to request.env["HTTP_REFERER"], notice: 'Ordenes Reenviadas con Exito'}
			else
				format.html {redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error tratando de reenviar las ordenes', error:errors}
			end	
		end
	end 


	private 
	def open_spreadsheet(file)
		case File.extname(file.original_filename)
		when ".csv" then Roo::Csv.new(file.path)
		when ".xls" then Roo::Excel.new(file.path)
		when ".xlsx" then Roo::Excelx.new(file.path)
		else raise "Unknown file type: #{file.original_filename}"
		end
	end
end
