class RequestDataMieleCore < ActiveRecord::Base

    # Metodo que sincroniza nuevos productos de Miele Core con los del B2C
    def self.synchronizeNewProductsWithMieleCore
        
        errors=[]
        begin 
            miele_core_tnrs = MieleCoreApi.getTnrProductsFromMieleCore("CL","B2C")["data"]

            if !miele_core_tnrs.empty?

                b2c_tnrs = Spree::Variant.all.pluck(:sku)
                tnrs_of_products_to_add = miele_core_tnrs - b2c_tnrs

                if tnrs_of_products_to_add.empty?
                    return {status: 200, message:"Los productos del B2C se encuentran sincronizados con Miele Core", errors:errors}
                end

                products_to_add_b2c = MieleCoreApi.find_products_by_tnr(tnrs_of_products_to_add)["data"]           
                products_to_add_b2c.each do |product|
                    begin 
                        if product["platform"].split(',').include?('B2B')
                            if product["name"] or product["name"] == ''
                                if product["product_prices"].find{|price| price["country"]["iso"] == "CL"} 

                                    sku = product["tnr"]
                                    name = product["name"]
                                    # Find Chilean Price 
                                    price = product["product_prices"].find{|price| price["country"]["iso"] == "CL"}['price']
                                    description = product["description"]

                                    if product["product_type"].blank?
                                        return {status: 400, message:"No se pudo crear el PRODUCTO con TNR:#{product["tnr"]}, ya que su TIPO(ejemplo: MDA,SDA,PAI) es NULO en MIELE CORE"}
                                    end

                                    new_product = Spree::Product.create!(
                                        sku: sku,
                                        name: name,
                                        price: price.to_i,
                                        description: description,
                                        shipping_category_id: 1,
                                        available_on: Time.now
                                    )

                                    new_product.specific_attribute.update(category:product["product_type"])
                                    new_product.reload

                                    Spree::Variant.find_by(sku:sku).update(core_id:product["id"])

                                else 
                                    errors.push({message_error: "Error en la sincronizacion del producto de TNR: #{product["tnr"]}", error: 'No se agrego el producto por que tiene un precio para CHILE vacio o nulo'})
                                end
                            else
                                errors.push({message_error: "Error en la sincronizacion del producto de TNR: #{product["tnr"]}", error: 'No se agrego el producto por que tiene un name vacio o nulo'})
                            end
                        else
                            errors.push({message_error: "Error en la sincronizacion del producto de TNR: #{product["tnr"]}", error: 'Incongruencia en MIELE Core, ya que el producto se encuentra definido para B2C pero no para el B2B'})
                        end 

                    rescue Exception => e
                        errors.push({message_error: "Error en la sincronizacion del producto de TNR: #{product["tnr"]}", error: e.message.to_s})
                    end
                end

                diff_errores = products_to_add_b2c.length - errors.length

                if diff_errores == 0
                    return {
                        status: 400,
                        message:"Error en la sincronizacion de creacion de Productos con Miele Core",
                        errors:errors,
                        miele_core_tnrs:miele_core_tnrs,
                        tnrs_of_products_to_add:tnrs_of_products_to_add,
                        products_to_add_b2c:products_to_add_b2c
                    }
                elsif diff_errores < products_to_add_b2c.length    
                    return {status: 400, message:"Algunos productos presentaron problemas en la sincronizacion de creacion on Miele Core", errors:errors}
                elsif diff_errores == products_to_add_b2c.length
                    return {status: 200, message:"La sincronizacion de creacion de Productos con Miele Core fue Exitosa", errors:errors}
                end
            else 
                return {status: 200, message:"No hay productos definidos en MIELE CORE para el B2C", errors:errors}
            end

        rescue Exception => e
            errors.push(e.to_s)
            return {status: 400, message:"Error en la sincronizacion de Productos con Miele Core", errors:errors}
        end
    end

    # Metodo que sincroniza los productos de miele core, actualizando sus informacion
    def self.synchronizeCreatedProductsWithMieleCore
        begin
                
            miele_core_tnrs = MieleCoreApi.getTnrProductsFromMieleCore("CL","B2C")["data"]
          
            # Se deshabilitan todos los productos que ya no se encuentren con el platform en B2C
            b2c_tnrs = Spree::Variant.pluck(:sku)
            tnr_products_to_disable =  b2c_tnrs - miele_core_tnrs
            products_to_disable = Spree::Variant.where(sku:tnr_products_to_disable)

            products_to_disable.each do |v|
                begin 
                    v.product.update(deleted_at:Time.now)
                rescue Exception => e
                    return {status: 400, message:"#{e} => no se pudo deshabilitar el producto con TNR:#{v.sku}, ya que no indica B2C en el platform de Miele Core"}
                end
            end

            # Se actualiza la informacion de los productos 
            miele_core_products = MieleCoreApi.find_products_by_tnr(miele_core_tnrs)["data"]

            miele_core_products.each do |mc_product|
                b2c_actual_variant_product = Spree::Variant.find_by(sku:mc_product["tnr"])
                b2c_actual_variant_product.update(core_id:mc_product['id'])
                product_stocks = mc_product["product_stocks"]
                product_prices = mc_product["product_prices"]

                if mc_product["product_type"].blank?
                    return {status: 400, message:"No se pudo actualizar el TIPO DE PRODUCTO(ejemplo: MDA,SDA,PAI) con TNR:#{mc_product["tnr"]}, porque es NULO en MIELE CORE"}
                end
                # Actualizando data Principal
                begin 
                    b2c_actual_product = b2c_actual_variant_product.product
                    b2c_actual_product.update!(name:mc_product["name"], description:mc_product["description"], deleted_at:nil)
                    b2c_actual_product.specific_attribute.update(category:mc_product["product_type"])
                    b2c_actual_product.reload
                rescue Exception => e
                    return {status: 400, message:"#{e} => no se pudo actualizar la informacion del producto con TNR:#{mc_product["tnr"]}"}
                end

                # Actualización del Stock
                if !product_stocks.empty?
                    begin
                        product_stocks.each do |stock_obj| 

                            country_id = stock_obj["country_id"]
                            stock = stock_obj["stock"]
                            stock_break = stock_obj["break"]
                                            
                            if country_id == 2 # Id equivalente a Chile
                                
                                b2c_actual_variant_product.stock_items.first.update(backorderable:false)
                                
                                if stock > 0
                                    b2c_actual_variant_product.stock_items.first.update(count_on_hand:stock) 
                                    b2c_actual_variant_product.update(discontinue_on:nil)
                                    b2c_actual_product.update(discontinue_on:nil)
                                    b2c_actual_product.specific_attribute.update(mandatory:false)                            
                                else

                                    b2c_actual_variant_product.stock_items.first.update(count_on_hand:0) 

                                    if stock_break == true
                                        b2c_actual_variant_product.update(discontinue_on:Time.now)
                                        b2c_actual_product.update(discontinue_on:Time.now)
                                        b2c_actual_product.specific_attribute.update(mandatory:false)         
                                        
                                    else # stock_break == false Opcion de disponibilidad de Cotizar
                                        b2c_actual_variant_product.update(discontinue_on:nil) 
                                        b2c_actual_product.update(discontinue_on:nil)
                                        b2c_actual_product.specific_attribute.update(mandatory:true)
                                    end
                                end
                                
                                break
                            end
                        end
                    rescue Exception => e
                        return {status: 400, message:"#{e} => no se pudo actualizar el stock de producto con TNR:#{mc_product["tnr"]}"}
                    end
                end

                # Actualización del Precio
                if !product_prices.empty?
                    begin
                        product_prices.each do |price_obj| 

                            country_id = price_obj["country_id"]
                            price = price_obj["price"]
                                                    
                            if country_id == 2 # Id equivalente a Chile
                                b2c_actual_variant_product.prices.first.update(amount:price)
                                break
                            end
                        end
                    rescue Exception => e
                        return {status: 400, message: "#{e} => no se pudo actualizar el precio de producto con TNR:#{mc_product["tnr"]}" }
                    end
                end                
            end

            return {status: 200, message: "Los productos provenientes de Miele Core se sincronizaron con exito"}

        rescue Exception => e
            return {status: 400, message: "Error en la sincronizacion de actualizacion de productos #{e.to_s}"}
        end
    end

end