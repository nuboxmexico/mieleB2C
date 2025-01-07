require 'rails_helper'

describe 'Product', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:base_product){create(:base_product)}
	
	context 'products pages' do
		before do 
			get_custom_current_store
			login_as(admin_user, scope: :spree_user)
		end

		it 'visit index admin path', js: true do
			create(:chile)
			visit spree.admin_path
			expect(page).to have_current_path(spree.dashboard_admin_reports_path)
			visit spree.admin_products_path
			expect(page).to have_current_path(spree.admin_products_path)
			page.first('.action-edit').click
			expect(page).to have_current_path(spree.edit_admin_product_path(Spree::Product.last))
			find('button[type="submit"]').click
		end
	end
end