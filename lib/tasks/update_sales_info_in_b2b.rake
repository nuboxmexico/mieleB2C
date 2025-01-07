#DEPRECATED
desc 'Actualiza la inforacíón de las ventas hechas en el B2C en el B2B'
task update_sales_info_in_b2b: :environment do
	puts 'Iniciando tarea: update_sales_info_in_b2b'
 	orders = Spree::Order.where(payment_state: "paid", send_to_api: false)
                       .where.not(completed_at: nil)
	response = ApiSingleton.create_order_api(orders)
end