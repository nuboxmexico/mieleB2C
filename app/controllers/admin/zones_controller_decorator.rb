module Spree
  module Admin
    ZonesController.class_eval do
    	def index
	    	@zones = Spree::Zone.paginate(page: params[:page], :per_page => 12)
	  	end
    end
  end
end
