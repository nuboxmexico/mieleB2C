require 'rails_helper'

RSpec.describe VirtualSupport, type: :model do
  let(:virtual_support){create(:virtual_support)}

  context 'can' do 
    it 'show?' do 
      virtual_support.update(active: false, url: nil)
      expect(virtual_support.active).to be false
      expect(virtual_support.url).to be nil
      expect(VirtualSupport.show?).to be false

      virtual_support.update(active: true, url: 'url')
      expect(virtual_support.active).to be true
      expect(virtual_support.url).not_to be nil
      expect(VirtualSupport.show?).to be true
    end
  end
end
