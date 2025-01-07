require 'rails_helper'

describe 'User', type: :feature do 
	let(:admin_user){create(:admin_user)}
	let(:client_user){create(:client_user)}

	before do 
		create(:miele_config)
	end 

	context 'User autentication' do
		it 'create new user' do
			visit spree.signup_path
			expect(page).to have_current_path(spree.signup_path)
			fill_in 'spree_user_name', with: 'Test name'
			fill_in 'spree_user_last_name', with: 'Test last name'
			fill_in 'spree_user_rut', with: '11.111.111-1'
			fill_in 'spree_user_email', with: 'test@test.cl'
			fill_in 'spree_user_password', with: 'password'
			fill_in 'spree_user_password_confirmation', with: 'password'
			find('input[type="submit"]').click
			last_user = Spree::User.last
			expect(last_user.email).to eq "test@test.cl"
			expect(page).to have_current_path(spree.root_path)
		end

		it 'login with created user' do
			visit spree.login_path
			expect(page).to have_current_path(spree.login_path)
			fill_in 'spree_user_email', with: client_user.email
			fill_in 'spree_user_password', with: 'password123'
			find('input[type="submit"]').click
			last_user = Spree::User.last
			login_as(last_user, scope: :user)
			expect(page).to have_current_path(spree.root_path)
		end


		it 'logout user', js: true do
			visit spree.login_path
			expect(page).to have_current_path(spree.login_path)
			fill_in 'spree_user_email', with: client_user.email
			fill_in 'spree_user_password', with: 'password123'
			find('input[type="submit"]').click
			last_user = Spree::User.last
			login_as(last_user, scope: :user)
			visit spree.logout_path
			expect(page).to have_current_path(spree.root_path)
			expect(page).to have_content("Sesión finalizada satisfactoriamente")
		end
		
	end

	context "recover password" do
		before do 
			get_custom_current_store
			visit spree.login_path
			expect(page).to have_current_path(spree.login_path)
			find('#recover_password').click
			expect(page).to have_current_path(spree.recover_password_path)
		end

		it 'try to recover pasword with exist user' do
			fill_in 'spree_user_email', with: admin_user.email
			find('input[name="commit"]').click
			expect(page).to have_current_path(spree.login_path)
		end
		
		it 'try to recover pasword with non register user' do
			admin_user.email = "fail@email.com"
			fill_in 'spree_user_email', with: admin_user.email
			find('input[name="commit"]').click
			expect(page).to have_current_path(spree.recover_password_path)
		end
	end

	context "edit user" do
		before do 
			login_as(admin_user, scope: :spree_user)
		end 
		
		it 'trying to change profile attributes', js: true do
			visit spree.account_path
			expect(page).to have_current_path(spree.account_path)
			click_link('Mis Datos')
			sleep(1)
			click_link('Editar')
			expect(page).to have_current_path(spree.edit_account_path)
			fill_in 'user_name', with: "Nuevo nombre"
			fill_in 'user_last_name', with: 'Nuevo apellido'
			fill_in 'user_rut', with: "111111111"
			fill_in 'user_email', with: admin_user.email
			fill_in 'user_password', with: 'newpassword123'
			fill_in 'user_password_confirmation', with: 'newpassword123'
			
			find('input[value="Actualizar"]').click
			expect(page).to have_current_path(spree.account_path)
		end
	end

	context 'account data' do 
		before do 
			login_as(admin_user, scope: :spree_user)
		end 

		it 'check ship address', js: true do 
			visit '/account'
			expect(page).to have_current_path('/account')

			expect(page).to have_content('Mi cuenta')
			expect(page).to have_link('Dirección de envio')

			click_link 'Dirección de envio'

			expect(page).to have_content('No existe dirección de envío')
		end

	end
end