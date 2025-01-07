require 'rails_helper'

describe 'Promotional Codes', type: :feature do 
  let(:base_product){create(:base_product)}
  let(:promotion) { create(:promotion_with_order_adjustment, code: 'CODIGO DE PRUEBA') }
  let(:user){create(:user_with_addresses)}
  before do 
    get_custom_current_store
    login_as(user, scope: :spree_user)
  end

  context 'apply' do 
    before do 
      create(:miele_config)
    end 
  
    it 'in order summary', js: true do 
      country = create(:chile, iso_name: 'iso_name')
      state = create(:state, name: 'Región Metropolitana de Santiago', country: country)
      expect(promotion.code).to eq 'CODIGO DE PRUEBA'
      visit spree.product_path(base_product)
      expect(page).to have_current_path(spree.product_path(base_product))
      expect(page).to have_selector('#add-to-cart-button')
      find('#add-to-cart-button').click
      wait_for_ajax
      expect(Spree::Order.last.line_items.size).to be 1

      visit spree.checkout_state_path(Spree::Order.last)
      expect(page).to have_current_path('/checkout/address')

      expect(page).to have_selector('#checkout-summary')
      summary_container = find('#checkout-summary')
      expect(find('#summary-order-total')).to have_content('$19')
      expect(summary_container).to have_link('Ingresar código de descuento')
      expect(summary_container).not_to have_selector('#promotional-code-form')
      expect(summary_container).not_to have_selector('#summary-discounts')
      click_link 'Ingresar código de descuento'
      wait_for_ajax
      expect(summary_container).to have_selector('#promotional-code-form')
      expect(summary_container).not_to have_link('Ingresar código de descuento')
      fill_in 'order[coupon_code_custom]', with: 'CODIGO DE PRUEBA'
      find('#apply-coupon-code').click
      wait_for_ajax
      expect(summary_container).not_to have_selector('#promotional-code-form')
      expect(summary_container).not_to have_link('Ingresar código de descuento')
      expect(summary_container).to have_selector('#summary-discounts')
      expect(summary_container).to have_content('Descuento $10')
      expect(find('#summary-order-total')).to have_content('$9')
    end
  end
end