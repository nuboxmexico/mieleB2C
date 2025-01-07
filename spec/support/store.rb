module Store
	def get_custom_current_store
		Spree::Store.create(name: "Spree Demo Site",
						url: "example.com",
						meta_description: nil,
						meta_keywords: nil,
						seo_title: nil,
						mail_from_address: "spree@example.com",
						default_currency: nil,
						code: "spree",
						default: true,
						created_at: "2018-08-21 20:46:02",
						updated_at: "2018-08-21 20:46:02")
		Spree::ShippingCategory.create(
                    name: "default"
        )
        Spree::StockLocation.create(
                name: "Default", 
                default: true,
                address1: "", 
                address2: "", 
                city: "", 
                state_id: nil, 
                state_name: nil, 
                country_id: 46, 
                zipcode: "", 
                phone: "", 
                active: true,
                backorderable_default: true, 
                propagate_all_variants: true,
             	admin_name: ""
        )
        Spree::Product.create(
                available_on: "2018-12-11 13:59:47",
                deleted_at: nil,
                tax_category_id: nil,
                shipping_category_id: 1,
                promotionable: true,
                discontinue_on: nil,
                name: "Test",
                slug: "test",
                price: 100,
                sku: "36008"
        )
        Spree::StockItem.create(
                stock_location_id: 1,
                variant_id: 1,
                count_on_hand: 100,
                backorderable: false
        )

	end
end