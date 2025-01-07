module Spree
  class QuotationMailer < BaseMailer
    
    def back_office(quotation, user)
      @quotation = quotation
      @user = user
      set_products_attachments(quotation.product)
      #Spree.t(:email_contact),
      to_email = Rails.application.secrets.contact_mails
      mail(to: to_email,
           from: 'onlineshop@miele.cl',
           subject: "Nueva cotización de #{@quotation.product.name}")
    end

    def customer(quotation, user)
      @quotation = quotation
      @user = user
      set_products_attachments(quotation.product)
      mail(to: @user.try(:email), 
           from: 'onlineshop@miele.cl',
           subject: "Nueva cotización de #{@quotation.product.name}",
           reply_to: Spree.t(:email_contact))
    end

    def set_products_attachments(product)
      if product.images.any?
        begin
            attachments.inline[product.images.try(:first).try(:attachment_file_name).try(:to_s)] = open(product.images.try(:first).try(:attachment).try(:url,:mini)).read
        rescue
            attachments.inline[product.images.try(:first).try(:attachment_file_name).try(:to_s)] = File.read(product.images.try(:first).try(:attachment).try(:path,:mini))
        end
      else
          attachments.inline['noimage/mini.png'] = File.read(Rails.root+'app/assets/images/noimage/mini.png')
      end
    end
  end
end