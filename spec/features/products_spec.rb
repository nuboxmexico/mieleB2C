require 'rails_helper'
	

describe 'Product', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:base_product){create(:base_product)}
	before do 
		get_custom_current_store
		login_as(admin_user, scope: :spree_user)
	end
	
	context 'pages' do
		before do 
			create(:miele_config)
		end 

		it 'visit specific page', js: true do
			visit spree.product_path(base_product)
			expect(page).to have_current_path(spree.product_path(base_product))
			expect(page).to have_content(base_product.name)
		end

		it 'add product from catalog', js: true do
			product_t = create(:product_in_stock)
			product_t.taxons << create(:taxon, name: 'Prueba')
			visit spree.nested_taxons_path(Spree::Taxon.last)
			expect(page).to have_current_path(spree.nested_taxons_path(Spree::Taxon.last))
			sleep(2)
			find('#add-'+product_t.id.to_s).click
			wait_for_ajax
			visit spree.cart_path
			expect(page).to have_current_path(spree.cart_path)
			expect(Spree::Order.last.line_items.size).to be(1)	
			expect(page).to have_content(Spree::Product.last.name)
		end

		it 'add product to cart and visit cart', js: true do
			visit spree.product_path(base_product)
			expect(page).to have_current_path(spree.product_path(base_product))
			expect(page).to have_content(base_product.name)
			find('#add-to-cart-button').click
			wait_for_ajax
			expect(Spree::Order.last.line_items.size).to be(1)	
			visit spree.cart_path
			expect(page).to have_current_path(spree.cart_path)
			expect(page).to have_content(Spree::Product.last.name)
		end
	end

	context 'customer show' do
		before do 
			create(:miele_config)
		end 

		it 'mandatory alert', js: true do 
			without_mandatory = create(:base_product)
			with_mandatory = create(:product_with_mandatory)

			visit spree.product_path(without_mandatory)
			expect(page).to have_current_path(spree.product_path(without_mandatory))
			expect(without_mandatory.specific_attribute.mandatory).to be false
			expect(page).not_to have_selector('.mandatory-alert')

			visit spree.product_path(with_mandatory)
			expect(page).to have_current_path(spree.product_path(with_mandatory))
			expect(with_mandatory.specific_attribute.mandatory).to be true
			expect(page).to have_selector('.mandatory-alert')
			expect(first('.mandatory-alert')).to have_content('Este producto requiere de accesorios mandatorios para su uso')
		end

		it 'instalation alert', js: true do 
			without_instalation = create(:base_product)
			with_instalation = create(:product_with_instalation)

			visit spree.product_path(without_instalation)
			expect(page).to have_current_path(spree.product_path(without_instalation))
			expect(without_instalation.specific_attribute.instalation).to be false
			expect(page).not_to have_selector('.instalation-alert')

			visit spree.product_path(with_instalation)
			expect(page).to have_current_path(spree.product_path(with_instalation))
			expect(with_instalation.specific_attribute.instalation).to be true
			expect(page).to have_selector('.instalation-alert')
			expect(first('.instalation-alert')).to have_content('Este producto requiere instalación por parte del equipo técnico de Miele para mantener la garantía')
		end

		it 'specific attributes' do 
			expect(base_product.specific_attribute).not_to be nil
			base_product.specific_attribute.update(accessories: nil)

			visit spree.product_path(base_product)
			expect(page).to have_current_path(spree.product_path(base_product))
			
			expect(page).to have_selector('.specific-attributes')
			expect(first('.specific-attributes')).to have_content('Especificaciones')
			expect(first('.specific-attributes')).to have_content('Características')
			expect(first('.specific-attributes')).to have_content('Especificaciones técnicas')
			expect(first('.specific-attributes')).to have_content('Funciones')
			expect(first('.specific-attributes')).to have_content('Especialidades de bebidas')
			expect(first('.specific-attributes')).to have_content('Diseño de los cestos')
			expect(first('.specific-attributes')).to have_content('Programa de lavado')
			expect(first('.specific-attributes')).to have_content('Programa de secado')
			expect(first('.specific-attributes')).to have_content('Cuidado y mantenimiento')
			expect(first('.specific-attributes')).to have_content('Eficiencia y sostenibilidad')
			
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.specs)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.features)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.technical_specs)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.product_functions)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.drink)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.basket_design)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.wash_program)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.dry_program)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.care)
			expect(first('.specific-attributes')).to have_content(base_product.specific_attribute.sustain)

			expect(base_product.specific_attribute.accessories).to be nil
			expect(first('.specific-attributes')).not_to have_content('Accesorios y suministro')
		end

		it 'attached files', js: true do 
			base_product.update(sku: 'testsku', specific_attribute: SpecificAttribute.new)
			visit upload_data_path
			wait_for_ajax
			attach_file :documents_upload, Rails.root + "spec/aux/testsku.pdf"
			click_button("Cargar documentos")
			wait_for_ajax

			expect(base_product.technical_documents.count).to be 1

			visit spree.product_path(base_product)
			expect(page).to have_current_path(spree.product_path(base_product))
			expect(page).to have_selector('.specific-attributes')
			expect(first('.specific-attributes')).to have_content('Descargas')
			first('.specific-attribute-container').click
			wait_for_ajax
			expect(first('.specific-attributes')).to have_content('Ficha técnica')
			expect(first('.specific-attributes')).to have_content('DESCARGAR')
			expect(first('.specific-attributes')).to have_selector('.download-file')
			new_window = window_opened_by{first('.download-file').click}
			wait_for_ajax
			page.switch_to_window(page.windows[1])
		  expect(page).to have_current_path(base_product.technical_documents.first.document.url(:original))
		end

		it 'quotation request', js: true do 
			country = create(:chile, iso_name: 'iso_name')
			state = create(:state, name: 'Región Metropolitana de Santiago', country: country)
			product = create(:product_to_quote)
			expect(Quotation.count).to be 0

			expect(product.specific_attribute.mandatory).to be true
			expect(product.specific_attribute.built_in).to be true
			expect(product.current_stock).to be 0

			visit spree.product_path(product)
			expect(page).to have_current_path(spree.product_path(product))

			expect(page).to have_content(product.name)
			expect(page).not_to have_selector('#add-to-cart-button')
			expect(page).to have_selector('#quotation-request')
			expect(page).to have_link(nil, href: main_app.quotation_new_path(product))
			expect(page).to have_selector('.built-in-explanation')
			expect(first('.built-in-explanation')).to have_content('Entrega posterior a 60 días')
			find('#quotation-request').click
			wait_for_ajax

			expect(page).to have_current_path(main_app.quotation_new_path(product))
			expect(page).to have_content('Solicitud de cotización')

			expect(page).to have_content('Ingresa tus datos')
			fill_in 'quotation[address][firstname]', with: 'Nombre'
			fill_in 'quotation[address][lastname]', with: 'Apellido'
			fill_in 'quotation[address][phone]', with: '0'

			expect(page).to have_content('Ingresa tus datos de despacho')
			all('#state-selector option')[1].select_option
			wait_for_ajax
			wait_for_ajax
			all('#quotation_address_comuna_id option')[1].select_option
			fill_in 'quotation[address][address1]', with: 'dirección 123'

			expect(page).to have_selector('.product-details')
			expect(first('.product-details')).to have_content(product.name)
			expect(first('.product-details')).to have_content(product.sku)
			# expect(first('.product-details')).to have_selector('img')
			expect(first('.product-details')).to have_content(Spree::Money.new(product.price))

			email_counter = ActionMailer::Base.deliveries.count
			expect(page).to have_selector('#submit-quotation')
			find('#submit-quotation').click
			wait_for_ajax

			expect(page).to have_current_path(main_app.success_quotation_request_path)
			expect(page).to have_selector('.quotation-success')
			expect(first('.quotation-success')).to have_content('Tu cotización ha sido registrada con éxito')
			expect(first('.quotation-success')).to have_content('Nuestro equipo de ventas se pondrá en contacto a la brevedad')
			expect(first('.quotation-success')).to have_content("Para más información o si tienes dudas con respecto a tu cotización, favor comunicarte al #{Spree.t(:phone_contact)} o a #{Spree.t(:email_contact)}")
			expect(first('.quotation-success')).to have_link(nil, href: spree.root_path)

			expect(Quotation.count).to be 1
			quotation = Quotation.first 
			expect(quotation.product).to eq product
			expect(quotation.address).not_to be nil
			expect(quotation.address.address1).to eq 'dirección 123'
			expect(quotation.user).not_to be nil
			expect(quotation.user.email).to eq 'oferusat@gmail.com'

			expect(ActionMailer::Base.deliveries.count - email_counter).to be 2
			receivers = ActionMailer::Base.deliveries.last(2).map{|mail| mail.to[0]}
			expect(receivers).to include('oferusat@gmail.com')
		end
	end

	context 'offer prices' do 
		let(:product){create(:product_with_offer_price)}
		before do 
			get_custom_current_store
			create(:miele_config)
		end

		it 'section', js: true do 
			visit spree.root_path
			expect(page).to have_current_path(spree.root_path)

			expect(product.offer_price_available?).to be true
			expect(page).to have_selector('#oportunities-section')
			expect(find('#oportunities-section')).to have_content('OPORTUNIDADES')
			find('#oportunities-section').click
			wait_for_ajax

			expect(page).to have_current_path(spree.oportunities_path)

			expect(page).to have_selector('.product-card')
			expect(all('.offer-price-container').count).to be all('.product-card').count
		end

		it 'show in product gallery', js: true do 
			visit spree.nested_taxons_path(product.depthest_taxon)
			expect(page).to have_current_path(spree.nested_taxons_path(product.depthest_taxon))
			
			expect(page).to have_selector('.offer-price-container')
			expect(first('.offer-price-container')).to have_content('90%')
			expect(page).to have_content(Spree::Money.new(product.master.prices[0].offer_price))
			expect(page).to have_selector('.strikethrough-price')
			expect(first('.strikethrough-price')).to have_content('$20')
		end

		it 'hide when is out of date range', js: true do 
			product.master.prices[0].update(offer_price_start: 7.days.ago, 
																			offer_price_end: 1.day.ago)
			visit spree.nested_taxons_path(product.depthest_taxon)
			expect(page).to have_current_path(spree.nested_taxons_path(product.depthest_taxon))
			
			expect(page).not_to have_selector('.offer-price-container')
			expect(page).not_to have_selector('.strikethrough-price')
		end

		it 'show in product detail', js: true do 
			visit spree.product_path(product)
			expect(page).to have_current_path(spree.product_path(product))
			
			expect(page).to have_content(Spree::Money.new(product.master.prices[0].offer_price))
			expect(page).to have_selector('.strikethrough-price')
			expect(first('.strikethrough-price')).to have_content(Spree::Money.new(product.price))
		end
	end

	context 'admin specific attributes' do 
		before do 
			create(:miele_config)
		end 
		it ' # show', js: true do 
			expect(base_product.specific_attribute).not_to be nil

			visit spree.edit_admin_product_path(base_product)
			expect(page).to have_current_path(spree.edit_admin_product_path(base_product))
			expect(page).to have_content(base_product.name)

			expect(page).to have_link('Atributos Miele', 
																href: spree.admin_product_specific_attributes_path(base_product))
			click_link 'Atributos Miele'
			expect(page).to have_current_path(spree.admin_product_specific_attributes_path(base_product))
			expect(page).to have_content('Atributos Miele')
			expect(page).to have_content("Especificaciones #{base_product.specific_attribute.specs}")
			expect(page).to have_content("Características #{base_product.specific_attribute.features}")
		end

		it ' # edit', js: true do 
			expect(base_product.specific_attribute).not_to be nil

			visit spree.admin_product_specific_attributes_path(base_product)
			expect(page).to have_current_path(spree.admin_product_specific_attributes_path(base_product))
			expect(page).to have_content('Atributos Miele')
			
			expect(page).to have_selector('.edit-specific-attribute')
			expect(all('.edit-specific-attribute').count).to be 19
			expect(page).to have_content("Especificaciones #{base_product.specific_attribute.specs}")
			expect(base_product.specific_attribute.specs).not_to eq 'Nuevas especificaciones'

			expect(page).not_to have_selector('#specific_attribute_specs_ifr')
			find("a[href='#{spree.admin_edit_product_specific_attribute_path(base_product, base_product.specific_attribute, 'specs', 'text')}']").click
			wait_for_ajax
			expect(page).to have_selector('#specific_attribute_specs_ifr')
			expect(page).to have_selector('input[type="submit"]')
			page.execute_script("tinyMCE.get('specific_attribute_specs').setContent('Nuevas especificaciones')")
			find('input[type="submit"]').click
			wait_for_ajax
			expect(page).to have_content('Especificaciones Nuevas especificaciones')
		end
	end

	context 'admin comparable attributes' do 
		before do 
			create(:miele_config)
		end 
		it ' # show', js: true do 
			comparable_attr1 = create(:comparable_attribute, name: 'Peso')
			comparable_attr2 = create(:comparable_attribute, name: 'Dimensiones')
			ProductComparableAttribute.create(product: base_product, 
																			  description: '10 KG', 
																			  comparable_attribute: comparable_attr1)
			ProductComparableAttribute.create(product: base_product, 
																			  description: '12 x 45 cm', 
																			  comparable_attribute: comparable_attr2)

			visit spree.edit_admin_product_path(base_product)
			expect(page).to have_current_path(spree.edit_admin_product_path(base_product))
			expect(page).to have_content(base_product.name)
			expect(page).to have_link('Atributos comparables', 
																href: spree.admin_product_comparable_attributes_path(base_product))
			click_link 'Atributos comparables'
			expect(page).to have_current_path(spree.admin_product_comparable_attributes_path(base_product))
			expect(page).to have_content('Atributos comparables')
			expect(page).to have_content('Peso 10 KG')
			expect(page).to have_content('Dimensiones 12 x 45 cm')
		end

		it ' # edit', js: true do 
			product = create(:product_with_comparable_attributes)
			visit spree.admin_product_comparable_attributes_path(product)
			expect(page).to have_current_path(spree.admin_product_comparable_attributes_path(product))

			expect(product.comparable_attrs.size).to be > 0
			sleep(2)
			expect(page).to have_selector('.edit-comparable-attribute')
			expect(all('.edit-comparable-attribute').count).to be product.comparable_attrs.size

			expect(page).to have_content('Peso 10 KG')
			expect(page).not_to have_selector('input[name="product_comparable_attribute[description]"]')
			first('.edit-comparable-attribute').click
			wait_for_ajax
			expect(page).to have_selector('input[name="product_comparable_attribute[description]"]')
			expect(page).to have_selector('input[type="submit"]')
			fill_in 'product_comparable_attribute[description]', with: '20 KG'
			find('input[type="submit"]').click
			wait_for_ajax
			expect(page).to have_content('Peso 20 KG')
		end


	end
end