require 'rails_helper'
include Spree::FrontendHelper
describe 'Taxones (categorias)', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:taxon){create(:taxon)}

	context 'visit taxon' do
		before do 
			create(:miele_config)
		end 
		before do 
			get_custom_current_store
			login_as(admin_user, scope: :spree_user)
		end

		it 'enter to a especific taxon page' do
			visit spree.nested_taxons_path(taxon)
			expect(page).to have_current_path(spree.nested_taxons_path(taxon))
		end
	end
end