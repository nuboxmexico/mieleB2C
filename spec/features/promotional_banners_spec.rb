require 'rails_helper'

describe 'Promotional Banners', type: :feature do 
  let(:user){create(:admin_user)}

  before do 
    login_as(user, scope: :spree_user)
  end

  context 'admin' do 
    before do 
      create(:miele_config)
    end 
    it 'add banner', js: true do 
      visit new_promotional_banner_path
      expect(page).to have_current_path(new_promotional_banner_path)

      expect(page).to have_content('Nuevo Banner')
      fill_in 'promotional_banner[title]', with: 'Banner de prueba'
      fill_in 'promotional_banner[alt]', with: 'Texto alternativo'
      fill_in 'promotional_banner[link]', with: 'https://www.google.com'
      attach_file 'promotional_banner[image]', Rails.root + "spec/aux/testsku.jpg"
      attach_file 'promotional_banner[mobile_image]', Rails.root + "spec/aux/testsku.jpg"
      click_button 'Guardar'

      expect(page).to have_current_path(promotional_banners_path)
      expect(page).to have_content('Banner de prueba')
      expect(page).to have_content('https://www.google.com')
    end

    it 'edit banner', js: true do
      banner = create(:promotional_banner)
      visit promotional_banners_path
      expect(page).to have_current_path(promotional_banners_path)

      previous_title = banner.title
      expect(page).to have_content(previous_title)
      expect(page).to have_selector('.edit-banner')
      expect(page).to have_link('Editar', href: edit_promotional_banner_path(banner))
      click_link 'Editar'

      expect(page).to have_current_path(edit_promotional_banner_path(banner))
      expect(page).to have_content('Editar Banner')
      fill_in 'promotional_banner[title]', with: 'Título modificado'
      fill_in 'promotional_banner[link]', with: 'https://www.google.com'
      click_button 'Guardar'

      expect(page).to have_current_path(promotional_banners_path)
      expect(page).to have_content('Título modificado')
      expect(page).to have_content('https://www.google.com')
      expect(page).not_to have_content(previous_title)
    end
  end

  context 'admin per taxon' do 
    before do 
      create(:miele_config)
    end 
    it 'show all', js: true do 
      taxon_1 = create(:taxon)
      taxon_2 = create(:taxon)
      taxon_3 = create(:taxon)

      visit categories_banners_path
      expect(page).to have_current_path(categories_banners_path)
      expect(Spree::Taxon.count).to be > 0

      wait_for_ajax
      expect(page).to have_content('Banners de categorías')
      expect(page).to have_content('CATEGORÍA BANNER')
      expect(page).to have_content(taxon_1.name)
      expect(page).to have_content(taxon_2.name)
      expect(page).to have_content(taxon_3.name)
    end

    it 'add banner', js: true do
      taxon_1 = create(:taxon)
      taxon_2 = create(:taxon)
      taxon_3 = create(:taxon)
      test_taxon = taxon_1.taxonomy.root

      visit categories_banners_path
      expect(Spree::Taxon.count).to be > 0
      
      expect(page).not_to have_selector('.category-banner')
      expect(page).to have_selector('.add-banner')
      expect(page).to have_link('Agregar banner', 
                                href: main_app.add_banner_to_category_path(test_taxon.id))
      first('.add-banner').click

      wait_for_ajax
      expect(page).to have_current_path(main_app.add_banner_to_category_path(test_taxon.id))
      expect(page).to have_content("Agregar banner")
      expect(page).to have_content("CATEGORÍA #{test_taxon.name}")
      expect(page).to have_selector('#promotional_banner_image')
      attach_file 'promotional_banner[image]', Rails.root + "spec/aux/testsku.jpg"
      click_button 'Guardar banner'

      wait_for_ajax
      expect(page).to have_current_path(categories_banners_path)
      expect(page).to have_selector('.category-banner')
    end

    it 
  end

  context 'per taxon' do 
    before do 
      create(:miele_config)
    end 
    let(:taxon){create(:taxon_with_banner)}

    it 'show banner in taxon gallery', js: true do 
      expect(taxon.banner).not_to be nil
      visit spree.nested_taxons_path(taxon)

      expect(page).to have_current_path(spree.nested_taxons_path(taxon))
      expect(page).to have_selector('.banner-image')
      expect(first('.banner-image')['style']).not_to be nil
    end
  end

  context 'in home' do 
    before do 
      create(:miele_config)
    end 

    it 'show banner title and CTA', js: true do 
      banner_1 = create(:promotional_banner, location: 0, link: 'url_banner_1')
      banner_2 = create(:promotional_banner, location: 1, link: 'url_banner_2')
      banner_3 = create(:promotional_banner, location: 2, link: 'url_banner_3')
      banner_4 = create(:promotional_banner, location: 3, link: 'url_banner_4')

      visit spree.root_path
      expect(page).to have_current_path(spree.root_path)

      expect(page).to have_selector('.banner-section')
      banners = all('.banner-section')
      expect(banners.count).to be 4

      expect(banners[0]).to have_content(banner_1.title)
      expect(banners[0]).to have_link(nil, href: banner_1.link)
      expect(banners[1]).to have_content(banner_2.title)
      expect(banners[1]).to have_link(nil, href: banner_2.link)
      expect(banners[2]).to have_content(banner_3.title)
      expect(banners[2]).to have_link(nil, href: banner_3.link)
      expect(banners[3]).to have_content(banner_4.title)
      expect(banners[3]).to have_link(nil, href: banner_4.link)
    end
  end
end