desc 'synchronize Miele Core Products with B2C'
task synchronize_miele_core_products: :environment do
	puts 'Iniciando tarea: Sincronizar productos de B2C con los de Miele Core'
    RequestDataMieleCore.synchronizeNewProductsWithMieleCore
    RequestDataMieleCore.synchronizeCreatedProductsWithMieleCore
end