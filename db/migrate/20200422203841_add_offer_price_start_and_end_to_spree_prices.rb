class AddOfferPriceStartAndEndToSpreePrices < ActiveRecord::Migration
  def change
    add_column :spree_prices, :offer_price_start, :date
    add_column :spree_prices, :offer_price_end, :date
  end
end
