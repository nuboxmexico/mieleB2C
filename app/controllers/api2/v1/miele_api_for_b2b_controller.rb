class Api2::V1::MieleApiForB2bController < ApplicationController
    
    protect_from_forgery with: :null_session, only: [:update_state_order, :create_or_update_tracking_info_order]
    skip_before_action :authenticate_user!, only: [:update_state_order, :create_or_update_tracking_info_order]
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authenticate, only: [:update_state_order, :create_or_update_tracking_info_order]

    
    # Endpoint disponibilizado a B2B que actualiza el estado de una orden o pedido, los cuales pueden ser Preparar, Enviar o Entregar 
    def update_state_order

        body_params = get_new_state_params()
        order_id =  body_params[:order_id]
        new_state =  body_params[:new_state_order]

        if !order_id.nil? and order_id.length>0
            begin 
                
                order = Spree::Order.find_by(number: order_id)
                shipment = order.shipments.first
                
                #########################################################################################################################
                if new_state == 'ready'
                    
                    if order.miele_state == "paid"
                        begin 
                            shipment.order.set_miele_state
                        rescue => exception
                            payload_response(400,"El State de la orden #{order_id} NO se logro actualizar a Preparar/Ready")
                        end

                        begin
                            Spree::ShipmentMailer.shipment_status_email(shipment).deliver_later!
                            payload_response(200,"El State de la orden #{order_id} se actualizo a Preparar/Ready")
                        rescue => exception
                            payload_response(200,"El State de la orden #{order_id} Se Actualizo a Preparar/Ready, PERO no se logro mandar el correo al Usuario Cliente")
                        end
                    else 
                        payload_response(400,"Error: Se solicita saltar un estado, ya que indica que se actualice el State de la orden #{order_id} a 'Preparar/Ready', PERO el estado anterior es #{order.miele_state}")
                    end

                #########################################################################################################################
                elsif new_state == 'ship'

                    if order.miele_state == "ready"
                        if !shipment.shipped? && shipment.can_ship?
                            begin
                                shipment.order.set_miele_state
                                shipment.ship!
                                payload_response(200,"El State de la orden #{order_id} se actualizo a Enviar/Ship") 
                            rescue => exception
                                if shipment.order.miele_state == "shipped"
                                    payload_response(400,"El State de la orden #{order_id} se logro actualizar a Enviar/Ship, pero hubo un problema con shipment.ship!")
                                else 
                                    payload_response(400,"El State de la orden #{order_id} NO se logro actualizar a Enviar/Ship")
                                end
                            end
                        end
                    else 
                        payload_response(400,"Error: Se solicita saltar un estado, ya que indica que se actualice el State de la orden #{order_id} a 'Enviar/Ship', PERO el estado anterior es #{order.miele_state}")
                    end

                #########################################################################################################################
                elsif new_state == 'deliver'

                    if order.miele_state == "shipped"
                        if shipment.shipped?
                            begin
                                shipment.order.set_miele_state
                            rescue => exception
                                payload_response(400,"El State de la orden #{order_id} NO se logro actualizar a Entregar/Deliver")  
                            end
                            begin
                                Spree::ShipmentMailer.shipment_status_email(shipment).deliver_later!
                                payload_response(200,"El State de la orden #{order_id} se actualizo a Entregar/Deliver")
                            rescue => exception
                                payload_response(200,"El State de la orden #{order_id} se actualizo a Entregar/Deliver, PERO no se logro mandar el correo al Usuario Cliente")  
                            end
                        end

                    else
                        payload_response(400,"Error: Se solicita saltar un estado, ya que indica que se actualice el State de la orden #{order_id} a 'Entregar/Deliver', PERO el estado anterior es #{order.miele_state}")
                    end 
                    
                #########################################################################################################################
                else 
                    payload_response(400,"El new_order_state obtenido no es Valido")
                end
                #########################################################################################################################
            rescue => exception
                payload_response(400,"El order_id consultado no existe")
            end
        else
            payload_response(400,"El order_id obtenido no es Valido")
        end
    end

    # Endpoint disponibilizado para B2B para actualizar el tracking_info de una orden 
    def create_or_update_tracking_info_order

        body_params = get_tracking_info_params()
        order_id =  body_params[:order_id]
        tracking_info =  body_params[:tracking_info]


        if !order_id.nil? and order_id.length>0
            
            begin
                order = Spree::Order.find_by(number: order_id)
                order.update(tracking_info: tracking_info)

                payload_response(200,"Se actualizo con exito el tracking info con '#{tracking_info}' de la orden '#{order_id}'")
            rescue => exception
                payload_response(400,"El order_id consultado no existe")
            end
        else
            payload_response(400,"El order_id obtenido no es Valido")
        end

    end


    private

        def payload_response(status,message) 
            # hash Object
            render status: status , json: {message:message} and return
        end

        def get_new_state_params
            return params.permit(:order_id, :new_state_order)
        end

        def get_tracking_info_params
            return params.permit(:order_id, :tracking_info)
        end
    
end
