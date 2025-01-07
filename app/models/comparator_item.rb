class ComparatorItem < ActiveRecord::Base
  belongs_to :comparator
  belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'spree_variant_id'
end
