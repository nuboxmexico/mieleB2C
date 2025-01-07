desc 'Recover carts'
task recover_carts: :environment do
	puts 'Iniciando tarea: Recuperar carros abandonados'
	if Spree::Order.recover_cart	
		puts 'Envío de correos de carro abandonado realizado con éxito'
	else
		puts 'Error al enviar correos de carro abandonado.'
	end
end