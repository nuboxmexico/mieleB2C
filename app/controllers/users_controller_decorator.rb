module Spree
  UsersController.class_eval do
    before_action :set_taxonomies
  	
    def show
      @orders = @user.orders.complete.paginate(page: params[:page], :per_page => 3).order('completed_at desc')
      respond_to do |format|
        format.html
        format.js
      end
    end

    def update
      if @user.update_attributes(user_params)
        if params[:user][:password].present?
          # this logic needed b/c devise wants to log us out after password changes
          Spree::User.reset_password_by_token(params[:user])
          bypass_sign_in(@user)
        end
        redirect_to spree.account_url, notice: Spree.t(:account_updated)
      else
        render :edit
      end
    end
    
  end
end