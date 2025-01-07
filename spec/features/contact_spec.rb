require 'rails_helper'

describe 'Contact', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:base_product){create(:base_product)}
	
	context 'user navigation' do
		before do 
			create(:miele_config)
		end 
		it 'send contact form', js: true do
			get_custom_current_store
			visit spree.contact_path
			fill_in 'message[name]', with: 'Test'
			fill_in 'message[subject]', with: 'Test message'
			fill_in 'message[email]', with: 'test@test.cl'
			fill_in 'message[body]', with: 'this is a test'
			first('.btn-contact').click
			expect(ActionMailer::Base.deliveries.count).to eq 1
			expect(page).to have_current_path(spree.contact_path)
			expect(page).to have_content('Formulario de contacto enviado con éxito!')
		end
	end
end