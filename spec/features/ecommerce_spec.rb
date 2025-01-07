require 'rails_helper'

describe 'E-commerce', type: :feature do 
	let(:admin_user){create(:admin_user)}
	context 'ecommerce page' do
		before do 
			create(:miele_config)
		end 
		before do 
			login_as(admin_user, scope: :spree_user)
		end

		it 'enter to principal ecommerce page' do
			visit spree.root_path
			expect(page).to have_current_path(spree.root_path)
		end

		it 'enter to about ecommerce page' do
			visit spree.store_about_path
			expect(page).to have_current_path(spree.store_about_path)
		end

		it 'enter to products ecommerce page' do
			visit spree.products_path
			expect(page).to have_current_path(spree.products_path)
		end

	end

end