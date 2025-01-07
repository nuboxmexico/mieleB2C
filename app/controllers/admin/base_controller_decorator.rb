module Spree
  module Admin
    BaseController.class_eval do
	  before_action :admin_route

    def configurations
    end

  	 private 
      def admin_route
      	if (request.env['PATH_INFO'] == "/es/admin" || request.env['PATH_INFO'] == "/admin") and current_user.has_spree_role?('admin')
        	redirect_to Spree.admin_path + '/reports/dashboard'
        elsif (request.env['PATH_INFO'] == "/es/admin" || request.env['PATH_INFO'] == "/admin") and current_user.has_spree_role?('Vendedor')
          redirect_to admin_orders_path
        end
      end
    end
  end
end