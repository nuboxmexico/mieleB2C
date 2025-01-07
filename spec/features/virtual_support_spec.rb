require 'rails_helper'

describe 'Virtual Support', type: :feature do 
  let(:virtual_support){create(:virtual_support, active: true)}
  let(:user){create(:admin_user)}
  before do 
    login_as(user, scope: :spree_user)
  end

  context 'requested by customer' do
  before do 
      create(:miele_config)
    end  
    it 'new', js: true do 
      expect(virtual_support.active).to be true
      expect(virtual_support.url).not_to be nil

      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)

      expect(page).to have_link('Agendar cita virtual', href: main_app.new_virtual_support_path)
      click_link 'Agendar cita virtual'

      expect(page).to have_current_path(main_app.new_virtual_support_path)
      expect(main_app.new_virtual_support_path).to eq '/agendamiento-cita-virtual'

      expect(page).to have_content(virtual_support.description)
      expect(page).to have_link('Agenda tu cita aquí', href: virtual_support.url)
    end

    it 'not available', js: true do 
      virtual_support.update(active: false, url: nil)
      expect(virtual_support.active).to be false
      expect(virtual_support.url).to be nil

      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)
      expect(page).not_to have_link('Agendar cita virtual', href: main_app.new_virtual_support_path)
    end
  end
end