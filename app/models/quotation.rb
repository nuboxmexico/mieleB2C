class Quotation < ActiveRecord::Base
  belongs_to :address, class_name: 'Spree::Address', foreign_key: :spree_address_id
  belongs_to :user, class_name: 'Spree::User', foreign_key: :spree_user_id
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id
end
