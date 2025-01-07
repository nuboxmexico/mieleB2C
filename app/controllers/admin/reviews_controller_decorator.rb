module Spree
  module Admin
    ReviewsController.class_eval do
    	def index
	    	@approved_reviews = Spree::Review.approved.where(product: @product)
	    	@reviews = Spree::Review.paginate(page: params[:page], :per_page => 12)
	  	end
    end
  end
end