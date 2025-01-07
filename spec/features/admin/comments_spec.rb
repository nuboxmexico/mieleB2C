require 'rails_helper'


describe 'Comment', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:base_product){create(:base_product)}
	
	context 'order pages' do
		before do 
			get_custom_current_store
			login_as(admin_user, scope: :spree_user)
		end
		it 'visit comments on order by admin', js: true do
			order = create(:order_ready_to_ship, user: admin_user, miele_state: 'paid')

			visit '/admin/orders'
			wait_for_ajax
			expect(page).to have_content(order.completed_at.strftime("%d-%m-%Y"))
			expect(page).to have_content(order.display_total)

			first('.action-edit').click
			click_link('Comentarios')

			fill_in 'comment_comment', with: 'this is a comment'
			click_button('Agregar comentario')
			wait_for_ajax
			expect(page).to have_content('this is a comment')
			expect(page).to have_content('oferusat@gmail.com')
			expect(page).to have_content('Comment ha sido creado con éxito')

			first('.btn-danger').click
			wait_for_ajax
			expect(page).to have_no_content('this is a comment')
			expect(page).to have_content('Comentario eliminado con éxito')
		end
	end
end