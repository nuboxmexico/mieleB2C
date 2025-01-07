require 'rails_helper'

RSpec.describe 'Comparator', type: :model do
  context 'get' do 
    let(:comparator){create(:comparator_with_products)}

    it 'comparable attributes names' do 
      response = comparator.attributes_names
      expect(response.class).to be Array
      expect(response.size).to be 2
      expect(response[0]).to eq 'Manejo'
      expect(response[1]).to eq 'Flexibilidad'
    end
  end
end