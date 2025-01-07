require 'rails_helper'

describe 'Comparator', type: :feature do 
  let(:user){create(:user_with_comparator)}
  let(:product){create(:base_product)}
  before do 
    login_as(user, scope: :spree_user)
  end
  
  context ' # buyer' do
    before do
      create(:miele_config)
    end
    
    it 'add product', js: true do 
      taxon = create(:taxon)
      product = create(:product_with_comparable_attributes, sku: 'product')
      product2 = create(:product_with_comparable_attributes, sku: 'product2')
      product3 = create(:product_with_comparable_attributes, sku: 'product3')

      visit spree.nested_taxons_path(taxon)
      expect(page).to have_current_path(spree.nested_taxons_path(taxon))
      expect(page).to have_link('Ver en comparador', 
                                href: comparator_add_product_path(product.id))
      expect(page).to have_selector('.comparator-btn')
      first('.comparator-btn').click
      expect(page).to have_current_path(comparator_path)
      wait_for_ajax
      expect(all('.product').size).to be 3
      expect(page).to have_content(product.name)
      expect(page).to have_content(product2.name)
      expect(page).to have_content(product3.name)
    end

    it 'download comparison', js: true do 
      taxon = create(:taxon)
      product = create(:product_with_comparable_attributes, sku: 'product')
      product2 = create(:product_with_comparable_attributes, sku: 'product2')
      product3 = create(:product_with_comparable_attributes, sku: 'product3')

      visit spree.nested_taxons_path(taxon)
      expect(page).to have_selector('.comparator-btn')
      first('.comparator-btn').click
      expect(page).to have_current_path(comparator_path)
      execute_script("$('#page-loader').remove()")
      execute_script("$('.section-header').css('margin-top', '150px')")
      wait_for_ajax
      expect(page).to have_link('Descargar comparación',
                                href: comparator_download_path(format: :pdf))
      first('.btn-tertiary').click
      expect(page.response_headers['Content-Disposition']).to eq 'attachment; filename="Comparación Miele.pdf"'
    end
  end
  
end  