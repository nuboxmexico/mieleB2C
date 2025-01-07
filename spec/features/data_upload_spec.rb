require 'rails_helper'
include Spree::FrontendHelper
describe 'Data Upload', type: :feature do 
	let(:admin_user){create(:admin_user)}

	context 'admin user upload' do
		before do 
			get_custom_current_store
			login_as(admin_user, scope: :spree_user)
		end

		it 'product', js: true do
			create(:taxonomy, name: 'ENZUNCHADO')
			Spree::Product.destroy_all
			expect(Spree::Product.count).to be 0

			visit upload_data_path
			wait_for_ajax
			attach_file :products_upload, Rails.root + "spec/aux/plantilla_productos.xlsx"
			click_button("Cargar productos")
			wait_for_ajax
			expect(page).to have_current_path(upload_data_path)
			# page.execute_script("$('.loader-page').remove()")
			expect(Spree::Product.count).to be 2
			expect(Spree::Variant.first.sku).to eq '17953'
			expect(Spree::Variant.first.prices[0].offer_price).to eq 109990.0
			expect(Spree::Variant.first.prices[0].offer_price_start).to eq Date.new(2020, 04, 21)
			expect(Spree::Variant.first.prices[0].offer_price_end).to eq Date.new(2020, 04, 30)
			expect(Spree::Product.first.name).to eq 'Producto 1'
			expect(Spree::Variant.last.sku).to eq 'testsku'
			expect(Spree::Product.last.name).to eq 'Producto 2'
			expect(Spree::Variant.last.prices[0].offer_price).to eq nil
			expect(Spree::Variant.last.prices[0].offer_price_start).to be nil
			expect(Spree::Variant.last.prices[0].offer_price_end).to be nil
		end

		it 'categories', js: true do
			visit upload_data_path
			wait_for_ajax
			expect(Spree::Taxon.count).to be 0
			attach_file :categories_upload, Rails.root + "spec/aux/plantilla_categorias.xlsx"
			click_button("Cargar categorías")
			wait_for_ajax
			expect(page).to have_current_path(upload_data_path)
			expect(Spree::Taxon.count).to be > 0
			expect(Spree::Taxonomy.last.name).to eq 'PRUEBA'
			expect(Spree::Taxon.last.name).to eq 'pruebotota'
		end

		it 'stock', js: true do
			create(:base_product, sku: 'testsku')
			visit upload_data_path
			wait_for_ajax
			attach_file :stock_upload, Rails.root + "spec/aux/plantilla_stock.xlsx"
			click_button("Cargar STOCK")
			wait_for_ajax
			expect(Spree::Product.last.stock_items[0].count_on_hand).to eq 33
		end

		it 'download stock' do 
			create(:product_in_stock, sku: '09563250')
			visit upload_data_path
			expect(page).to have_current_path(upload_data_path)
			first('#download-stock').click
			expect(page.response_headers['Content-Disposition']).to eq 'attachment; filename="plantilla_stock_'+Date.today.strftime("%d/%m/%Y")+'.xlsx"'
		end

		it 'download stock' do 
			create(:product_in_stock, sku: '09563250')
			visit upload_data_path
			expect(page).to have_current_path(upload_data_path)
			expect(page).to have_link('Descargar Productos', href: main_app.download_products_path(format: :xlsx))
			click_link('Descargar Productos')
			expect(page.response_headers['Content-Disposition']).to eq 'attachment; filename="plantilla_productos_'+Date.today.strftime("%d/%m/%Y")+'.xlsx"'
		end

		it 'technical document', js: true do
			create(:base_product, sku: 'testsku')
			visit upload_data_path
			wait_for_ajax
			attach_file :documents_upload, Rails.root + "spec/aux/testsku.pdf"
			click_button("Cargar documentos")
			wait_for_ajax
			expect(Spree::Product.last.technical_documents.size).to eq 1
			visit spree.edit_admin_product_path(Spree::Product.last)
			click_link('Documentos')
			wait_for_ajax
			first('.btn-danger').click
			first('.swal2-confirm').click
			wait_for_ajax
			expect(Spree::Product.last.technical_documents.size).to eq 0
		end

		it 'images', js: true do
			create(:base_product, sku: 'testsku')
			visit upload_data_path
			wait_for_ajax
			attach_file :images_upload, Rails.root + "spec/aux/testsku.jpg"
			click_button("Cargar imagenes")
			wait_for_ajax
			expect(Spree::Product.last.images.size).to eq 1
		end

		it 'comparable attributes', js: true do 
			visit upload_data_path
			wait_for_ajax

			expect(page).to have_selector('#comparable_attributes_file')
			attach_file :comparable_attributes_file, Rails.root.join('spec', 'aux', 'comparable_attributes.xlsx')
			click_button 'Cargar atributos comparables'

			expect(page).to have_current_path(upload_data_path)
			expect(find('.alertify-notifier')).to have_content('Atributos comparables cargados con éxito')
		end
	end
end