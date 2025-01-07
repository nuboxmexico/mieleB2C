require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  context 'get' do 
    let(:product){create(:base_product, sku: '9563220')}

    it 'comparable attributes comparison' do 
      product.taxons << create(:taxon, name: 'Hornos')
      comparable_attr = create(:comparable_attribute, name: 'Manejo')
      create(:product_comparable_attribute, product: product,
                                            comparable_attribute: comparable_attr,
                                            description: 'descripción')

      expected_response = {"Manejo" => "descripción"}

      response = product.comparable_attrs_comparison
      expect(response.class).to be Hash
      expect(response).to eq expected_response
    end

    it 'comparable attributes' do 
      product.taxons << create(:taxon, name: 'Hornos')
      comparable_attr = create(:comparable_attribute, name: 'Manejo')
      create(:product_comparable_attribute, product: product,
                                            comparable_attribute: comparable_attr,
                                            description: 'descripción')

      response = product.comparable_attrs
      expect(response.class).to be ProductComparableAttribute::ActiveRecord_AssociationRelation
      expect(response.size).to be 1
    end

    it 'depthest taxon' do 
      product = create(:base_product)
      taxonomy = create(:taxonomy)
      level_1 = create(:taxon, name: 'Level 1', taxonomy: taxonomy, parent: nil)
      level_2 = create(:taxon, name: 'Level 2', taxonomy: taxonomy, parent: level_1)
      level_3 = create(:taxon, name: 'Level 3', taxonomy: taxonomy, parent: level_2)
      product.taxons << level_1
      product.taxons << level_2
      product.taxons << level_3

      expect(product.depthest_taxon).to eq level_3
    end

    it 'to quote confirmation' do 
      without_specific_attrs = create(:base_product, specific_attribute: nil)
      expect(without_specific_attrs.to_quote?).to be nil
 
      not_quotable = create(:base_product)
      expect(not_quotable.to_quote?).to be false

      quotable = create(:product_to_quote)
      expect(quotable.to_quote?).to be true
    end
  end

  context 'offer price' do 
    let(:product){create(:product_with_offer_price)}

    it 'available' do 
      expect(product.offer_price_available?).to be true

      product.master.prices[0].update(offer_price_start: 7.days.ago, 
                                      offer_price_end: nil)
      expect(product.offer_price_available?).to be true

      product.master.prices[0].update(offer_price_start: nil)
      expect(product.offer_price_available?).to be true

      product.master.prices[0].update(offer_price_start: nil, 
                                      offer_price_end: nil)
      expect(product.offer_price_available?).to be true
    end

    it 'not available' do 
      product.master.prices[0].update(offer_price_start: 7.days.ago, 
                                      offer_price_end: 1.day.ago)
      expect(product.offer_price_available?).to be false
    end
  end
end