class PromotionalBanner < ActiveRecord::Base
  belongs_to :taxon, class_name: 'Spree::Taxon', foreign_key: 'spree_taxon_id'

  has_attached_file :image, styles: {
    large: "1920x1200",
    medium: "300x300", 
    thumb: "100x100" 
  }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_attached_file :mobile_image, styles: {
    normal: "500x500", 
    thumb: "100x100" 
  }
  validates_attachment_content_type :mobile_image, content_type: /\Aimage\/.*\Z/

  enum location: {
    home_1: 0,
    home_2: 1,
    home_3: 2,
    home_4: 3,
    sidebar_category: 4,
    category_bar: 5,
    taxon: 6
  }

  def location_help_url
      if self.location == "category_bar" 
        return ActionController::Base.helpers.asset_path('banners/category_bar.jpg')
      elsif self.location == "home_1" 
        return ActionController::Base.helpers.asset_path('banners/home_1.jpg')
      elsif self.location == "home_2" 
        return ActionController::Base.helpers.asset_path('banners/home_2.jpg')
      elsif self.location == "home_3" 
        return ActionController::Base.helpers.asset_path('banners/home_3.jpg')
      elsif self.location == "home_4" 
        return ActionController::Base.helpers.asset_path('banners/home_4.jpg')
      elsif self.location == "sidebar_category" 
        return ActionController::Base.helpers.asset_path('banners/sidebar_category.jpg')
      else
        return "#"
      end
  end

  def self.location_options
    return [
      ['Home 1', 0],
      ['Home 2', 1],
      ['Home 3', 2],
      ['Home 4', 3],
      ['Sidebar en específico', 4],
      ['Barra de categorías', 5]
    ]
  end
end
