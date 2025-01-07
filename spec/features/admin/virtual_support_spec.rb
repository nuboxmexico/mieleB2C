require 'rails_helper'

describe 'Admin Virtual Support', type: :feature do 
  let(:admin_user){create(:admin_user)}
  before do 
    create(:virtual_support)
    create(:chile)
    get_custom_current_store
    login_as(admin_user, scope: :spree_user)
  end

  context 'manage' do 

    it 'new vrtual support', js: true do 
      visit spree.admin_path
      expect(page).to have_link('Citas Virtuales', href: main_app.virtual_support_path)
      click_link 'Citas Virtuales'

      expect(VirtualSupport.count).to be 1
      expect(page).to have_current_path(main_app.virtual_support_path)
      expect(page).to have_content('Administración del módulo de Citas Virtuales')
  
      check 'virtual_support_active'
      fill_in 'virtual_support[subtitle]', with: 'Subtítulo del soporte virtual'
      fill_in 'virtual_support[description]', with: 'Descripción del soporte virtual'
      fill_in 'virtual_support[subdescription]', with: 'Subdescripción del soporte virtual'
      fill_in 'virtual_support[url]', with: 'https://www.google.cl'
      attach_file 'virtual_support[background_image]', "#{Rails.root}/spec/aux/testsku.jpg"
      find('input[type="submit"]').click

      expect(page).to have_current_path(main_app.virtual_support_path)
      expect(find('.alertify-notifier')).to have_content('Información de cita virtual editada con éxito')
      
      expect(VirtualSupport.count).to be 1
      virtual_support = VirtualSupport.first
      expect(virtual_support.active).to be true
      expect(virtual_support.description).to eq 'Descripción del soporte virtual' 
      expect(virtual_support.url).to eq 'https://www.google.cl'
      expect(virtual_support.background_image.present?).to be true
    end
  end
end