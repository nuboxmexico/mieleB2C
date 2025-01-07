Spree::Taxon.class_eval do
  has_many :comparable_attributes, class_name: 'ComparableAttribute', foreign_key: 'spree_taxon_id', dependent: :destroy
  has_one :banner, class_name: 'PromotionalBanner', foreign_key: 'spree_taxon_id', dependent: :destroy

	before_save :save_featured
  
	def save_featured
	end
end

