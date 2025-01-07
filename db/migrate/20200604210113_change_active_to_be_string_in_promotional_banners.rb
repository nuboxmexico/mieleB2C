class ChangeActiveToBeStringInPromotionalBanners < ActiveRecord::Migration
  def change
  	change_column :promotional_banners, :active, :string
  end
end
