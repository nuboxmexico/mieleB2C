require 'rails_helper'

describe 'Order', type: :feature do 
  let(:admin_user){create(:admin_user)}
  before do 
    get_custom_current_store
    login_as(admin_user, scope: :spree_user)
  end

  context 'admin shipment' do 
    let(:order){create(:order_ready_to_ship, user: admin_user)}

    it 'save tracking numbers', js: true do
      expect(order.shipment_state).to eq 'ready'
      order.shipments.first.update(tracking: nil,
                                   alternative_tracking: nil)

      expect(order.shipments.count).to be 1
      expect(order.shipments.first.tracking.present?).to be false
      expect(order.shipments.first.alternative_tracking.present?).to be false
      
      visit spree.edit_admin_order_path(order)
      expect(page).to have_current_path(spree.edit_admin_order_path(order))
      
      expect(page).to have_content(order.number)
      expect(page).to have_content(Spree.t(:no_tracking_present_enterprise, enterprise: 'Alas'))
      expect(page).to have_selector('.edit-tracking')
      first('.edit-tracking').click
      wait_for_ajax
      expect(page).not_to have_content(Spree.t(:no_tracking_present_enterprise, enterprise: 'Alas'))
      expect(page).to have_selector('input[id="tracking"]')
      expect(page).to have_selector('.save-tracking')
      fill_in 'tracking', with: 'tracking alas'
      first('.save-tracking').click
      wait_for_ajax
      expect(page).to have_content('tracking alas')

      expect(page).to have_content(Spree.t(:no_tracking_present_enterprise, enterprise: 'Starken'))
      expect(page).to have_selector('.edit-alternative-tracking')
      first('.edit-alternative-tracking').click
      wait_for_ajax
      expect(page).not_to have_content(Spree.t(:no_tracking_present_enterprise, enterprise: 'Starken'))
      expect(page).to have_selector('input[id="alternative_tracking"]')
      expect(page).to have_selector('.save-alternative-tracking')
      fill_in 'alternative_tracking', with: 'tracking starken'
      first('.save-alternative-tracking').click
      wait_for_ajax
      expect(page).to have_content('tracking starken')
      expect(order.shipments.first.tracking).to eq 'tracking alas'
      expect(order.shipments.first.alternative_tracking).to eq 'tracking starken'
    end
  end

  context 'completed' do 
    it 'download', js: true do 
      visit spree.admin_orders_path
      expect(page).to have_current_path(spree.admin_orders_path)
      expect(page).to have_link('Descargar ordenes', href: spree.admin_orders_path(format: :xlsx))
      click_link 'Descargar ordenes'
      expect(page.response_headers['Content-Disposition']).to eq "attachment; filename=\"Ordenes_#{Date.today.strftime("%d-%m-%Y")}.xlsx\""
    end

    it 'download by date range', js: true do 
      visit spree.admin_orders_path
      expect(page).to have_current_path(spree.admin_orders_path)
      
      expect(page).to have_link('Descargar ordenes', href: spree.admin_orders_path(format: :xlsx))
      fill_in 'q[created_at_gt]', with: '01/01/2020'
      fill_in 'q[created_at_lt]', with: '31/12/2020'

      click_link 'Descargar ordenes'
      expect(page.response_headers['Content-Disposition']).to eq "attachment; filename=\"Ordenes_#{Date.today.strftime("%d-%m-%Y")}.xlsx\""
    end
  end
end