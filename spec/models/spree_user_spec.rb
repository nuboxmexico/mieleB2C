require 'rails_helper'

RSpec.describe Spree::User, type: :model do
  let(:user){create(:user)}

  context 'comparator' do 
    it 'get' do 
      expect(user.comparator).to be nil
      user.comparators << create(:comparator)
      expect(user.comparator.class).to be Comparator
    end
  end

  context 'data' do 
    it 'to tickets' do 
      response = user.data_to_tickets
      expect(response.class).to be Hash

      expect(response.has_key?(:names)).to be true
      expect(response.has_key?(:lastname)).to be true
      expect(response.has_key?(:email)).to be true
      expect(response.has_key?(:rut)).to be true

      expect(response[:names]).to eq user.name
      expect(response[:lastname]).to eq user.last_name
      expect(response[:email]).to eq user.email
      expect(response[:rut]).to eq user.rut
    end
  end
end