class AddActiveToPromotionalBanners < ActiveRecord::Migration
  def change
  	add_column :promotional_banners, :active , :boolean
  end
end
