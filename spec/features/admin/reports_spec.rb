require 'rails_helper'

describe 'Reports', type: :feature do 
	let(:admin_user){create(:admin_user)}
	
	context 'reports in admin' do
		before do 
			get_custom_current_store
			login_as(admin_user, scope: :spree_user)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.admin_path
			expect(page).to have_current_path(spree.dashboard_admin_reports_path)
			visit spree.admin_reports_path
			expect(page).to have_current_path(spree.admin_reports_path)
			expect(page).to have_content("Total de venta")
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.promotions_admin_reports_url
			expect(page).to have_current_path(spree.promotions_admin_reports_url)
			visit spree.promotions_pdf_admin_reports_url
			expect(page).to have_current_path(spree.promotions_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.sales_product_total_admin_reports_url
			expect(page).to have_current_path(spree.sales_product_total_admin_reports_url)
			visit spree.sales_product_total_pdf_admin_reports_url
			expect(page).to have_current_path(spree.sales_product_total_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.viewed_product_total_admin_reports_url
			expect(page).to have_current_path(spree.viewed_product_total_admin_reports_url)
			visit spree.viewed_product_total_pdf_admin_reports_url
			expect(page).to have_current_path(spree.viewed_product_total_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.customers_over_time_admin_reports_url
			expect(page).to have_current_path(spree.customers_over_time_admin_reports_url)
			visit spree.customers_over_time_pdf_admin_reports_url
			expect(page).to have_current_path(spree.customers_over_time_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.visits_over_time_admin_reports_url
			expect(page).to have_current_path(spree.visits_over_time_admin_reports_url)
			visit spree.visits_over_time_pdf_admin_reports_url
			expect(page).to have_current_path(spree.visits_over_time_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.visits_by_page_admin_reports_url
			expect(page).to have_current_path(spree.visits_by_page_admin_reports_url)
			visit spree.visits_by_page_pdf_admin_reports_url
			expect(page).to have_current_path(spree.visits_by_page_pdf_admin_reports_url)
		end

		it 'index of reports', js: true do
			create(:chile)
			visit spree.searches_admin_reports_url
			expect(page).to have_current_path(spree.searches_admin_reports_url)
		end

	end

end