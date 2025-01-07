require 'rails_helper'

RSpec.describe DataUpload, type: :model do
  context 'import' do 
    it 'comparable attributes' do 
      file = ActionDispatch::Http::UploadedFile.new({
        filename: 'comparable_attributes.xlsx',
        content_type: 'file/xlsx',
        tempfile: File.new(Rails.root.join('spec', 'aux', 'comparable_attributes.xlsx'))
      })
      product = create(:base_product, sku: '9563220')
      product.taxons << create(:taxon, name: 'hornos')
      expect(product.comparable_attrs.size).to be 0

      product2 = create(:base_product, sku: '7111190')
      product2.taxons << create(:taxon, name: 'encimeras')
      expect(product2.comparable_attrs.size).to be 0

      expect(DataUpload.comparable_attributes(file)).to be true
      expect(product.comparable_attrs.size).to be 10
      expect(product2.comparable_attrs.size).to be 6
    end
  end
end
