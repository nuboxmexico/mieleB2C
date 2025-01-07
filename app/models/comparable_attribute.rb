class ComparableAttribute < ActiveRecord::Base
  belongs_to :taxon, class_name: 'Spree::Taxon', foreign_key: 'spree_taxon_id' 
  has_many :product_comparable_attributes, dependent: :destroy
end
