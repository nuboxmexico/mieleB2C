# Preview all emails at http://localhost:3000/rails/mailers/quotation
class QuotationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/quotation/back_office
  def back_office
    Spree::QuotationMailer.back_office(Quotation.last)
  end

  # Preview this email at http://localhost:3000/rails/mailers/quotation/customer
  def customer
    Spree::QuotationMailer.customer(Quotation.last)
  end

end
