FactoryBot.define do 
  factory :comparator do 
    spree_user {nil}

    factory :comparator_with_products do 
      after :create do |comparator|
        skus = ['9563220', '9563221']
        skus.each do |sku|
          product = create(:base_product, sku: sku)
          product.taxons << create(:taxon, name: 'Hornos')
          create(:product_comparable_attribute, 
                    product: product,
                    comparable_attribute: create(:comparable_attribute, name: 'Manejo'),
                    description: 'descripción')
          create(:product_comparable_attribute, 
                    product: product,
                    comparable_attribute: create(:comparable_attribute, name: 'Flexibilidad'),
                    description: 'descripción')

          comparator.variants << product.master
        end
      end
    end
  end
end