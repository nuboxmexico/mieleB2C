class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  has_many :orders, class_name: "Spree::Order"
  belongs_to :user, :class_name => 'Spree::User', :foreign_key => 'user_id'
end
