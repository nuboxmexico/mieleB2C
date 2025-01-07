class ProductComparableAttribute < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'spree_product_id'
  belongs_to :comparable_attribute
end
