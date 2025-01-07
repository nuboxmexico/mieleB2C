class QuotationsController < Spree::BaseController
  invisible_captcha only: [:create, :update], honeypot: :gotcha
  include Spree::Core::Engine.routes.url_helpers
  include Spree::Core::Engine.helpers
  include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Order
  layout '/spree/layouts/spree_application'

  def new
    @product = Spree::Product.find_by(slug: params[:product_id])
    @quotation = Quotation.new
    @country = Spree::Country.find_by_name('Chile')
  end

  def create
    product = Spree::Product.find(params[:quotation][:product])
    address_params = params[:quotation][:address]
                      .permit(Spree::PermittedAttributes.address_attributes)
    @quotation = Quotation.new
    @quotation.address = Spree::Address.new(address_params)
    @quotation.product = product
    if spree_current_user
      @user = spree_current_user 
    else
      user_params = params[:quotation][:user]
                        .permit(Spree::PermittedAttributes.user_attributes)
      if (user = Spree::User.find_by(rut: params[:quotation][:user][:rut]))
        @user = user 
      else
        @user = Spree::User.new(user_params)
      end
    end
    @quotation.user = @user

    respond_to do |format|
      if @quotation.save
        Spree::QuotationMailer.customer(@quotation, @user).deliver_later
        Spree::QuotationMailer.back_office(@quotation, @user).deliver_later
        format.html{ redirect_to main_app.success_quotation_request_path }
      else
        format.html{ redirect_to main_app.quotation_new_path(product) }
      end
    end
  end

  def success
  end
end
