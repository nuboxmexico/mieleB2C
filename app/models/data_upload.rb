class DataUpload
	def self.upload_categories(file)
		if !(spreadsheet = DataUpload.open_spreadsheet(file))
			return false, [-2]
		end
		headers = []
		spreadsheet.row(1).each_with_index {|header,i| headers.push(header)	}
		if !headers.include? 'CAT' or !headers.include? 'SUB1' or 
			 !headers.include? 'SUB2' or !headers.include? 'SUB3'
			return false, [-1]
		else
			file_errors = []
			i = 0
			spreadsheet.each(business_unit: 'CAT', family: 'SUB1', sub_family: 'SUB2', specific: 'SUB3') do |row|
				if i > 0
					begin
						taxonomy = Spree::Taxonomy.find_by(name: row[:business_unit]) 
						taxonomy = Spree::Taxonomy.create(name: row[:business_unit]) unless taxonomy
						parent_taxon = Spree::Taxon.find_by(name: row[:business_unit])
						if row[:family]!= ''
							taxon1 = parent_taxon.children.find_by(name: row[:family].try(:downcase))
							unless taxon1
								taxon1 = Spree::Taxon.create(
									name: row[:family].try(:downcase),
									parent: parent_taxon,
									taxonomy: taxonomy
									)
							end
						end
						if row[:sub_family]!= ''
							taxon2 = taxon1.children.find_by(name: row[:sub_family].try(:downcase))
							unless taxon2
								taxon2 = Spree::Taxon.create(
									name: row[:sub_family].try(:downcase),
									parent: taxon1,
									taxonomy: taxonomy
									)
							end
						end
						if row[:specific]!= ''
							taxon3 = taxon2.children.find_by(name: row[:specific].try(:downcase))
							unless taxon3
								taxon3 = Spree::Taxon.create(
									name: row[:specific].try(:downcase),
									parent: taxon2,
									taxonomy: taxonomy
									)
							end
						end
					rescue Exception => e
						file_errors.push(i+1)
					end
				end
				i = i + 1
			end
		end
		return true, file_errors
	end

	def self.upload_products(file)
		if !(spreadsheet = DataUpload.open_spreadsheet(file))
			return false, [-2]
		end
		headers = []
		spreadsheet.row(1).each_with_index {|header,i| headers.push(header)	}
		unless  headers.include? 'TNR' and
						headers.include? 'Business Unit' and
						headers.include? 'Familia' and
						headers.include? 'Subfamilia' and
						headers.include? 'Específico' and
						headers.include? 'Nombre' and
						headers.include? 'Descripción' and
						headers.include? 'Precio' and
						headers.include? 'Precio oferta' and
						headers.include? 'Precio oferta desde' and
						headers.include? 'Precio oferta hasta' and
						headers.include? 'Mandatorio' and
						headers.include? 'Canal' and
						headers.include? 'Retirable' and
						headers.include? 'Despachable' and
						headers.include? 'Tipo' and
						headers.include? 'Built-in' and
						headers.include? 'Instalación' and
						headers.include? 'Outlet' and
						headers.include? 'Peso (kg)' and
						headers.include? 'Alto mm' and
						headers.include? 'Largo mm' and
						headers.include? 'Ancho mm' and
						headers.include? 'Descripción larga (html)' and
						headers.include? 'Especificaciones' and
						headers.include? 'Características' and
						headers.include? 'Especificaciones técnicas' and
						headers.include? 'Funciones' and
						headers.include? 'Especialidades de bebidas' and
						headers.include? 'Diseño de los cestos' and
						headers.include? 'Programa de lavado' and
						headers.include? 'Programa de secado' and
						headers.include? 'Cuidado y mantenimiento' and
						headers.include? 'Eficiencia y sostenibilidad' and
						headers.include? 'Seguridad' and
						headers.include? 'Accesorios y suministros'
			return false, [-1]
		end
		i = 0
		row_errors = []
		spreadsheet.each(id: 'TNR', cat: 'Business Unit', category_name: 'Familia', sub_category: 'Subfamilia', sub_family: 'Específico', name: 'Nombre', description: 'Descripción', price: 'Precio', weight: 'Peso (kg)',height: 'Alto mm',width: 'Ancho mm',depth: 'Largo mm',long_description: 'Descripción larga (html)',mandatory: 'Mandatorio', channel: 'Canal', can_retire: 'Retirable', can_ship: 'Despachable', type: 'Tipo', built_in: 'Built-in', instalation: 'Instalación', outlet: 'Outlet', specs: "Especificaciones", features: "Características", technical_specs: "Especificaciones técnicas", product_functions: "Funciones", drink: "Especialidades de bebidas", basket_design: "Diseño de los cestos", wash_program: "Programa de lavado", dry_program: "Programa de secado", care: "Cuidado y mantenimiento", sustain: "Eficiencia y sostenibilidad", accessories: "Accesorios y suministros", security: 'Seguridad', offer_price: 'Precio oferta', offer_price_start: 'Precio oferta desde', offer_price_end: 'Precio oferta hasta') do |row|
			if i > 0
				begin
					taxon_sub1 = nil
					taxon_sub2 = nil
					taxon_sub3 = nil
					taxon = nil
					if !(row[:cat].nil?)
						if (taxon = Spree::Taxon.find_by(name: row[:cat]))
							sku = row[:id]
							sku = sku.to_i.to_s if sku.class != String
							if (p = Spree::Variant.find_by(sku: sku))	
								p.product.name = row[:name]
								p.product.price = row[:price].to_i
								p.price = row[:price].to_i
								p.product.description = row[:description]
								p.product.long_description = row[:long_description]
								p.weight = row[:weight]
								p.save
								p.product.save
							else
								p = Spree::Product.create!(
											sku: sku,
											name: row[:name],
											price: row[:price].to_i,
											description: row[:description],
											shipping_category_id: 1,
											available_on: Time.now,
											weight: row[:weight],
											height: row[:height],
											width: row[:width],
											depth: row[:depth],
											long_description: row[:long_description]
										)							
								p = p.master
							end
							p.stock_items << Spree::StockItem.new unless p.stock_items[0]
							p.stock_items[0].count_on_hand = row[:stock] ? row[:stock] : 0
							p.stock_items[0].save

							p.prices[0].offer_price  = row[:offer_price].try(:to_d)
							p.prices[0].offer_price_start  = Date.strptime(row[:offer_price_start], "%d/%m/%Y") if row[:offer_price_start] and row[:offer_price_start] != '' rescue nil
							p.prices[0].offer_price_end  = Date.strptime(row[:offer_price_end], "%d/%m/%Y") if row[:offer_price_end] and row[:offer_price_end] != '' rescue nil

							if p.prices[0].offer_price_start.blank?
								p.prices[0].offer_price_start  = row[:offer_price_start] rescue nil
							end
							if p.prices[0].offer_price_end.blank?
								p.prices[0].offer_price_end  = row[:offer_price_end] rescue nil
							end							
			 				p.prices[0].save!

							if p.product.specific_attribute
								p.product.specific_attribute.update(
									mandatory: row[:mandatory].try(:upcase) == 'SI',
									channel: row[:channel],
									can_retire: row[:can_retire].try(:upcase) == 'SI',
									can_ship: row[:can_ship].try(:upcase) == 'SI',
									category: row[:type],
									built_in: row[:built_in].try(:upcase) == 'SI',
									instalation: row[:instalation].try(:upcase) == 'SI',
									outlet: row[:outlet].try(:upcase) == 'SI',
									specs: row[:specs],
									features: row[:features],
									technical_specs: row[:technical_specs],
									product_functions: row[:product_functions],
									drink: row[:drink],
									basket_design: row[:basket_design],
									wash_program: row[:wash_program],
									dry_program: row[:dry_program],
									care: row[:care],
									security: row[:security],
									sustain: row[:sustain],
									accessories: row[:accessories]
								)
							else
								p.product.specific_attribute = SpecificAttribute.create(
									mandatory: row[:mandatory].try(:upcase) == 'SI',
									channel: row[:channel],
									can_retire: row[:can_retire].try(:upcase) == 'SI',
									can_ship: row[:can_ship].try(:upcase) == 'SI',
									category: row[:type],
									built_in: row[:built_in].try(:upcase) == 'SI',
									instalation: row[:instalation].try(:upcase) == 'SI',
									outlet: row[:outlet].try(:upcase) == 'SI',
									specs: row[:specs],
									features: row[:features],
									technical_specs: row[:technical_specs],
									product_functions: row[:product_functions],
									drink: row[:drink],
									basket_design: row[:basket_design],
									wash_program: row[:wash_program],
									dry_program: row[:dry_program],
									care: row[:care],
									security: row[:security],
									sustain: row[:sustain],
									accessories: row[:accessories]
								)
							end
							if taxon
								c = Spree::Classification.find_by(product_id: p.id, taxon_id: taxon.id)
								if c.nil?
									c = Spree::Classification.new
									c.product_id= p.id	   
									c.taxon_id= taxon.id
									c.save
								end
							end
							taxon_sub1 = taxon.children.find_by(name: row[:category_name].try(:downcase))
							if taxon_sub1
								c = Spree::Classification.find_by(product_id: p.id, 
																									taxon_id: taxon_sub1.id)
								unless c
									Spree::Classification.create(
											product_id: p.id,
											taxon_id: taxon_sub1.id
										)
								end
							end
							if taxon_sub1
								taxon_sub2 = taxon_sub1.children.find_by(name: row[:sub_category].try(:downcase))
								if taxon_sub2
									c = Spree::Classification.find_by(product_id: p.id, 
																										taxon_id: taxon_sub2.id)
									unless c
										Spree::Classification.create(
												product_id: p.id,
												taxon_id: taxon_sub2.id
											)
									end
								end
							end
							if taxon_sub2
								taxon_sub3 = taxon_sub2.children.find_by(name: row[:sub_family].try(:downcase))
								if taxon_sub3
									c = Spree::Classification.find_by(product_id: p.id, 
																										taxon_id: taxon_sub3.id)
									unless c
										Spree::Classification.create(
												product_id: p.id,
												taxon_id: taxon_sub3.id
											)
									end
								end
							end
						else 
							row_errors.push(i+1)
						end
					else
						row_errors.push(i+1)
					end
				rescue Exception => e
					puts "-----------------------#{e.inspect}"
					row_errors.push(i+1)
				end
			end
			i = i + 1
		end
		return true, row_errors
	end

	def self.update_stock(file)
		if !(spreadsheet = DataUpload.open_spreadsheet(file))
			return false, [-2]
		end
		headers = []
		spreadsheet.row(1).each_with_index {|header,i| headers.push(header)	}
		if !headers.include? 'TNR' or !headers.include? 'Stock' 
			return false, [-1]
		else
			i = 0
			file_errors = []
			spreadsheet.each(id: 'TNR', quantity: 'Stock') do |row|
				if i > 0
					if (v = Spree::Variant.find_by(sku: row[:id]))
						begin
							if v.stock_items.first
								v.stock_items.first.update(count_on_hand: row[:quantity])
							else
							 	v.stock_items << Spree::StockItem.create(count_on_hand: row[:quantity], stock_location_id: 1)
							 	v.stock_items.first.save
						  end 
						rescue Exception => e
							file_errors.push(i+1)
						end
					else
						file_errors.push(i+1)
					end
				end
				i = i + 1
			end
		end
		return true, file_errors
	end

	def self.upload_related_products(file)
		return false, [-2] if !(spreadsheet = DataUpload.open_spreadsheet(file))
		headers = []
		spreadsheet.row(1).each_with_index { |header, i| headers << (header) }
		if !headers.include? 'TNR base' or !headers.include? 'TNR relacionado'
			return false, [-1]
		else
			row_index = 0
			file_errors = []
			default_relation_type = Spree::RelationType.find_or_create_by(name: 'Default', applies_to: 'Spree::Product')
			spreadsheet.each(sku_product: 'TNR base', sku_related_product: 'TNR relacionado') do |row|
				if row_index > 0
					variant_product = Spree::Variant.find_by(sku: row[:sku_product].to_s.strip)
					variant_related_product = Spree::Variant.find_by(sku: row[:sku_related_product].to_s.strip)
					if !variant_product.nil? && !variant_related_product.nil?
						begin
							Spree::Relation.find_or_create_by( 
								relatable_type: 'Spree::Product',
								related_to_type: 'Spree::Product',
								relation_type_id: default_relation_type.id,
								relatable: variant_product.product,
								related_to: variant_related_product.product
								)
						rescue Exception => e
							file_errors << [row_index + 1]
						end
					else
						file_errors << [row_index + 1]
					end
				end
				row_index += 1
			end
		end
		return true, file_errors
	end

	def self.upload_offer_prices(file)
		return false, [-2] if !(spreadsheet = DataUpload.open_spreadsheet(file))
		headers = []
		spreadsheet.row(1).each_with_index { |header, i| headers << (header) }
		if !headers.include? 'TNR' or 
			 !headers.include? 'Precio oferta' or
			 !headers.include? 'Precio oferta desde' or 
			 !headers.include? 'Precio oferta hasta'
			return false, [-1]
		else
			row_index = 0
			file_errors = []
			spreadsheet.each(id: 'TNR', offer_price: 'Precio oferta', offer_price_start: 'Precio oferta desde', offer_price_end: 'Precio oferta hasta') do |row|
				if row_index > 0
					if (variant = Spree::Variant.find_by(sku: row[:id].to_s.strip))
						date_from = row[:offer_price_start]
						date_to = row[:offer_price_end]
						begin
							date_from = Date.strptime(date_from ,"%d/%m/%Y") if !date_from.blank?
							date_to = Date.strptime(date_to ,"%d/%m/%Y") if !date_to.blank?
							raise if date_from && date_to && date_from > date_to
							variant.prices.first.update_columns(offer_price: row[:offer_price].try(:to_d), 
																									offer_price_start: date_from, 
																									offer_price_end: date_to)
						rescue Exception => e
							file_errors.push(row_index + 1)
						end
					else
						file_errors.push(row_index + 1)
					end
				end
				row_index += 1
			end
		end
		return true, file_errors
	end

	def self.upload_technical_files(files)
		files.each do |file|
			begin
				extn = File.extname file.original_filename  
				name_file = File.basename file.original_filename, extn
				name_file = name_file.split("_")
				sku_p = name_file[0]
				type_p = name_file[1]				
				if (v = Spree::Variant.find_by(sku: sku_p))
					p = v.product
					if !p.nil?
						technical_document = TechnicalDocument.new
						technical_document.spree_product_id = p.id
						technical_document.document = file
						technical_document.document_type = type_p	
						technical_document.save
					end
				end
			rescue Exception => e 

			end
		end
	end

	def self.upload_images(files)
		begin
			files.each do |file|
				extn = File.extname file.original_filename  
				name_file = File.basename file.original_filename, extn
				name_file = name_file.split("_")
				sku_p = name_file[0]
				variant = Spree::Variant.find_by(sku: sku_p)
				if variant
					p = variant.product
					if p	
						p.images.create!(:attachment => file)
						p.save!
					end
				end
			end
			return true
		rescue Exception => e
		end
	end

	def self.upload_products_metadata(file)
		unless spreadsheet = DataUpload.open_spreadsheet(file)
			return false, [-2]
		end
		headers = []
		spreadsheet.row(1).each_with_index {|header,i| headers.push(header.strip)	}
		unless headers.include? 'Meta title' and headers.include? 'Meta name' and headers.include? 'Meta description' and headers.include? 'TNR'  
			return false, [-1]
		end
			row_index = 0
			file_errors = []
			spreadsheet.each( sku: "TNR", meta_title: "Meta title", meta_keywords: "Meta name", meta_description: "Meta description") do |row|
				if row_index > 0
					product = Spree::Variant.find_by(sku: row[:sku].to_s.strip).product
					begin
						product.update!(meta_title: row[:meta_title],
													meta_description: row[:meta_description],
													meta_keywords: row[:meta_keywords])
					rescue => e
						file_errors << [row_index + 1]
					end
				end
				row_index += 1 
			end
		return true, file_errors
	end

	def self.upload_categories_metadata(file)
		unless spreadsheet = DataUpload.open_spreadsheet(file)
			return false, [-2]
		end
		headers = []
		spreadsheet.row(1).each_with_index {|header,i| headers.push(header.strip)	}
		unless headers.include? 'Meta title' and headers.include? 'Meta keywords' and headers.include? 'Meta description' and headers.include? 'Name'  
			return false, [-1]
		end
			row_index = 0
			file_errors = []
			spreadsheet.each( name: "Name", meta_title: "Meta title", meta_keywords: "Meta keywords", meta_description: "Meta description") do |row|
				if row_index > 0
					category = Spree::Taxon.find_by(name: row[:name].to_s.strip)
					begin
						category.update!(meta_title: row[:meta_title],
														meta_description: row[:meta_description],
														meta_keywords: row[:meta_keywords])
					rescue => e
						file_errors << [row_index + 1]
					end
				end
				row_index += 1 
			end
		return true, file_errors
	end

	def self.comparable_attributes(file)
		unless (spreadsheet = DataUpload.open_spreadsheet(file))
			return false
		end
		spreadsheet.each_with_pagename do |name, sheet|
			taxon = Spree::Taxon.find_by(name: name.downcase)
			if taxon
				attributes = []
				sheet.row(1).drop(2).each do |attribute|
					comparable_attribute = ComparableAttribute.find_by(name: attribute, 
																								 						 taxon: taxon)
					unless comparable_attribute
						comparable_attribute = ComparableAttribute.create(name: attribute, 
																								 						  taxon: taxon)
					end
					attributes << comparable_attribute
				end
				i = 0
				sheet.each do |row|
					if i > 0
						sku = row.shift
						sku = sku.to_i.to_s if sku.class != String
						row.shift # usado para remover la columna con el nombre del producto
						product = Spree::Variant.find_by(sku: sku).try(:product)
						if product
							attributes.each_with_index do |attribute, i|
								attr_aux = product.comparable_attributes.find_by(name: attribute.name)
								if attr_aux
									product.product_comparable_attributes
												 .find_by(comparable_attribute: attr_aux)
												 .update(description: row[i])
								else
									ProductComparableAttribute.create(product: product,
																										comparable_attribute: attribute,
																										description: row[i])
								end
							end
						end
					end
					i += 1
				end
			end
		end
		return true
	end

	private 
		def self.open_spreadsheet(file)
			case File.extname(file.original_filename)
			when ".csv" then Roo::Csv.new(file.path)
			when ".xls" then Roo::Excel.new(file.path)
			when ".xlsx" then Roo::Excelx.new(file.path)
			else return nil
			end
		end
end