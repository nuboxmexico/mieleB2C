object false
@variants = Spree::Variant.includes({ option_values: :option_type }, :product, :default_price, :images, { stock_items: :stock_location })
            .ransack(params[:q]).result.paginate(page: params[:page], :per_page => params[:per_page])         
node(:count) { @variants.count }
node(:total_count) { @variants.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:pages) { @variants.total_pages }

child(@variants => :variants) do
  extends "spree/api/v1/variants/big"
end
