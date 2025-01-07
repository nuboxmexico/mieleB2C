class TechnicalDocument < ActiveRecord::Base
	belongs_to :product, class_name: 'Spree::Product', foreign_key: 'spree_product_id'
	has_attached_file :document
	validates_attachment :document, content_type: { content_type: %w(application/pdf) }
end