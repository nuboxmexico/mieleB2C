FactoryBot.define do
  factory :base_product, class: Spree::Product do
    sequence(:name) { |n| "Product ##{n} - #{Kernel.rand(9999)}" }
    description { "Test description" }
    price {19.99}
    cost_price {17.00}
    sku { "testsku - #{Kernel.rand(9999)}" }
    available_on { 1.year.ago }
    deleted_at {nil}
    shipping_category { |r| Spree::ShippingCategory.first || r.association(:shipping_category) }
    taxons { Spree::Taxon.first ? Spree::Taxon.all : [create(:taxon)] }
    specific_attribute {create(:specific_attribute)}
    # ensure stock item will be created for this products master
    before(:create) { create(:stock_location) if Spree::StockLocation.count == 0 }

    factory :custom_product do
      name {'Custom Product'}
      price {17.99}

    end

    factory :product_with_offer_price do 
      after :create do |product|
        product.master.prices[0].update(offer_price: 1.99, 
                                        offer_price_start: Date.today,
                                        offer_price_end: Date.today + 7.days)
      end
    end

    factory :product_with_taxons do
        after(:create) { |base_product| base_product.taxons << create(:taxon) }
  	end
    
    factory :product do
    
      factory :product_in_stock do
        after :create do |product|
          product.master.stock_items.first.adjust_count_on_hand(10)
        end
      end

      factory :product_with_option_types do
        after(:create) { |product| create(:product_option_type, product: product) }
      end
    end

    factory :product_with_comparable_attributes do 
      after(:create) do |product|
        create(:product_comparable_attribute, 
                  product: product,
                  comparable_attribute: create(:comparable_attribute, 
                                                  name: 'Peso'),
                  description: '10 KG')
        create(:product_comparable_attribute, 
                  product: product,
                  comparable_attribute: create(:comparable_attribute, 
                                                  name: 'Dimensiones'),
                  description: '12 x 45 cm')
      end
    end

    # factory :product_with_specific_attributes do 
    #   after :create do |product|
    #     product.
    #   end
    # end

    factory :product_with_mandatory do 
      after :create do |product|
        product.specific_attribute = create(:specific_attribute)
        product.save
        product.specific_attribute.update(mandatory: true)
      end
    end

    factory :product_with_instalation do 
      after :create do |product|
        product.specific_attribute = create(:specific_attribute)
        product.save
        product.specific_attribute.update(instalation: true)
      end
    end

    factory :product_to_quote do
      after :create do |product|
        product.master.stock_items.first.adjust_count_on_hand(0)
        product.specific_attribute = create(:specific_attribute)
        product.save
        product.specific_attribute.update(mandatory: true, built_in: true)
      end   
    end

  end
end