class AddOfferPriceToSpreePrice < ActiveRecord::Migration
  def change
    add_column :spree_prices, :offer_price, :decimal, :precision => 10, :scale => 2
  end
end
