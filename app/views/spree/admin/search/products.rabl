object false
if params[:ids]
          @products = Spree::Product.where(id: params[:ids].split(",").flatten)
        else
          @products = Spree::Product.ransack(params[:q]).result
        end
        @products = @products.distinct.paginate(page: params[:page], :per_page => params[:per_page])

node(:count) { @products.count }
node(:total_count) { @products.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @products.total_pages }
child(@products => :products) do
  attributes :id, :name
end
