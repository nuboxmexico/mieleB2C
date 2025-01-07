module Spree
  class ShipmentMailer < BaseMailer
    def shipment_status_email(shipment)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      if @shipment.order.miele_state == 'paid'
        subject_content =  "#{Spree.t('order_mailer.confirm_email.subject')} N° #{@shipment.order.number}" 
      elsif @shipment.order.miele_state == 'ready'
        subject_content =  "Tu pedido N° #{@shipment.order.number} está en preparación para ser enviado." 
      elsif @shipment.order.miele_state == 'shipped'
        subject_content = "Tu pedido N° #{@shipment.order.number} ha sido enviado."
      elsif @shipment.order.miele_state == 'delivered'
        subject_content = "Tu pedido N° #{@shipment.order.number} ha sido entregado."
      end
      mail(to: @shipment.order.email, bcc: Rails.application.secrets.contact_mails, subject: subject_content)
    end
  end
end
