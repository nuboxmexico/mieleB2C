require 'rails_helper'
require 'rake'
include Spree::FrontendHelper
describe 'Order', type: :feature do 
	let(:admin_user){create(:admin_user)}
  before do 
    get_custom_current_store
    login_as(admin_user, scope: :spree_user)
  end

  context 'user show' do 
    before do 
      create(:miele_config)
    end 
    let(:order){create(:order_ready_to_ship, user: admin_user)}

    it 'tracking numbers', js: true do 
    	create(:line_item, order: order)
    	order.line_items.first.product.specific_attribute.update(category: 'MDA')
    	order.line_items.last.product.specific_attribute.update(category: 'PAI')
    	order.shipments.first.update(tracking: 'PAI tracking',
    															 alternative_tracking: 'MDA y SDA tracking')

      expect(order.shipment_state).to eq 'ready'
      expect(order.line_items.count).to be 2
      expect(order.mda_and_sda_products.count).to be 1
      expect(order.pai_products.count).to be 1
      expect(order.shipments.first.tracking).not_to be nil
      expect(order.shipments.first.alternative_tracking).not_to be nil
      
      visit spree.order_path(order)

      expect(page).to have_content(order.number)
      expect(page).to have_selector('.tracking-container')
      tracking_containers = all('.tracking-container')
      expect(tracking_containers.count).to be 2
      expect(tracking_containers[0]).to have_content('Envío 1')
      expect(tracking_containers[0]).to have_content("Starken: #{order.shipments.first.alternative_tracking}")
      expect(tracking_containers[1]).to have_content('Envío 2')
      expect(tracking_containers[1]).to have_content("Alas: #{order.shipments.first.tracking}")
    end

  end

	context 'crons ' do
		before do 
			get_custom_current_store
			Rake::Task.define_task(:environment)
		end
		
		it 'send abandoned carts email' do
			create(:order_with_totals, user: admin_user)
			load Rails.root.join("lib/tasks/recover_carts.rake")
			task = Rake::Task["recover_carts"]

			sleep 3
			expect{task.invoke}.to output(/Envío de correos de carro abandonado realizado con éxito/).to_stdout
			expect(Spree::Order.last.recovered).to eq true
			expect(ActionMailer::Base.deliveries.count).to be > 0
		end
	end
end