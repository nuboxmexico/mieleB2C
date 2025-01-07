require 'rails_helper'

RSpec.describe Spree::Order, type: :model do
  context 'get' do 
    let(:order){create(:order_ready_to_ship)}

    it 'mda products' do 
      expect(order.line_items.count).to be 1
      order.line_items.first.product.specific_attribute.update(category: 'MDA')
      expect(order.line_items.first.product.specific_attribute.category).to eq 'MDA'
      expect(order.mda_and_sda_products.count).to be 1
      
      order.line_items.first.product.specific_attribute.update(category: 'SDA')
      expect(order.mda_and_sda_products.count).to be 1

      order.line_items.first.product.specific_attribute.update(category: 'PAI')
      expect(order.mda_and_sda_products.count).to be 0
    end

    it 'sda products' do 
      expect(order.line_items.count).to be 1
      order.line_items.first.product.specific_attribute.update(category: 'PAI')
      expect(order.line_items.first.product.specific_attribute.category).to eq 'PAI'
      expect(order.pai_products.count).to be 1
      
      order.line_items.first.product.specific_attribute.update(category: 'MDA')
      expect(order.pai_products.count).to be 0
    end
  end
end