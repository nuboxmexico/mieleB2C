require 'rails_helper'

describe 'Store Notice', type: :feature do 
  let(:user){create(:admin_user)}
  before do 
    login_as(user, scope: :spree_user)
  end
  
  context 'manage' do 
    before do 
      create(:miele_config)
    end 
    it 'show available notices', js: true do 
      create(:country, name: 'Chile')
      visit spree.admin_path
      expect(page).to have_current_path(spree.dashboard_admin_reports_path)
      expect(page).to have_link('Anuncios', href: store_notices_path)
    end

    it 'new notice', js: true do 
      visit store_notices_path
      expect(page).to have_current_path(store_notices_path)
      
      expect(StoreNotice.count).to be 0
      expect(page).to have_content('Anuncios')
      expect(page).to have_link('Nuevo anuncio', href: new_store_notice_path)
      click_link 'Nuevo anuncio'
      expect(page).to have_current_path(new_store_notice_path)

      expect(page).to have_content('Nuevo anuncio')
      expect(page).to have_selector('#store_notice_content')
      expect(page).to have_selector('#store_notice_link')
      fill_in 'store_notice[content]', with: 'Nuevo anuncio'
      fill_in 'store_notice[link]', with: 'http://www.tienda.cl'
      click_button 'Crear anuncio'

      expect(page).to have_current_path(store_notices_path)
      expect(StoreNotice.count).to be 1
      expect(page).to have_content('Nuevo anuncio')
      expect(page).to have_link('http://www.tienda.cl', href: 'http://www.tienda.cl')
    end

    it 'only one notice', js: true do 
      expect(StoreNotice.count).to be 0
      visit store_notices_path
      expect(page).to have_link('Nuevo anuncio', href: new_store_notice_path)

      create(:store_notice)
      expect(StoreNotice.count).to be 1
      visit store_notices_path
      expect(page).not_to have_link('Nuevo anuncio', href: new_store_notice_path)
    end

    it 'remove notice', js: true do 
      create(:store_notice)
      expect(StoreNotice.count).to be 1
      visit store_notices_path
      expect(page).not_to have_link('Nuevo anuncio', href: new_store_notice_path)

      expect(page).to have_selector('.remove-notice')
      expect(page).to have_link(href: store_notice_path(StoreNotice.first))
      find('.remove-notice').click

      expect(page).to have_current_path(store_notices_path)
      expect(StoreNotice.count).to be 0
      expect(page).to have_link('Nuevo anuncio', href: new_store_notice_path)
    end
  end

  context 'store front' do 
    before do 
      create(:miele_config)
    end 
    it 'show notice with link', js: true do 
      notice = create(:store_notice)
      expect(StoreNotice.any?).to be true
      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)

      expect(page).to have_selector('.store-notice')
      expect(first('.store-notice')).to have_content(notice.content)
      expect(first('.store-notice')).to have_link('VER MÁS', href: notice.link)
    end

    it 'show notice without link' do 
      notice = create(:store_notice, link: nil)
      expect(StoreNotice.any?).to be true
      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)

      expect(page).to have_selector('.store-notice')
      expect(first('.store-notice')).to have_content(notice.content)
      expect(first('.store-notice')).not_to have_link('VER MÁS')
    end

    it 'no notice available' do 
      expect(StoreNotice.any?).to be false
      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)

      expect(page).not_to have_selector('.store-notice')
    end
  end
end