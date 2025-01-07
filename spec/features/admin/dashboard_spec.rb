require 'rails_helper'

describe 'Dashboard', type: :feature do 
	let(:admin_user){create(:admin_user)}
	
	context 'admin dashboard' do 
		before do 
			create(:miele_config)
		end 
		it 'enter dashboard' do
			create(:chile)
			visit spree.login_path
			expect(page).to have_current_path(spree.login_path)
			fill_in 'spree_user_email', with: admin_user.email
			fill_in 'spree_user_password', with: 'password123'
			find('input[type="submit"]').click
			visit spree.admin_path
			expect(page).to have_current_path(spree.dashboard_admin_reports_path)
		end
	end

end