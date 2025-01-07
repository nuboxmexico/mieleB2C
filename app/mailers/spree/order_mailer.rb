module Spree
  class OrderMailer < BaseMailer
    def confirm_email(order, resend = false)
      @order = order
      subject = "#{Spree.t('order_mailer.confirm_email.subject')} N° #{@order.number}"
      mail(to: @order.email, bcc: Rails.application.secrets.contact_mails, subject: subject, reply_to: Spree.t(:email_contact))
    end

    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.cancel_email.subject')} ##{@order.number}"
      mail(to: @order.email, subject: subject, reply_to: Spree.t(:email_contact))
    end

    def recovering_cart(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      mail(to: @order.email, subject: 'Tenemos esto esperando por tí', reply_to: Spree.t(:email_contact))
    end
  end
end
