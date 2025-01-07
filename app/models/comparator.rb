class Comparator < ActiveRecord::Base
  belongs_to :spree_user
  has_many :items, class_name: 'ComparatorItem', foreign_key: 'comparator_id'
  has_many :variants, through: :items
  
  def self.create_cookie(cookies)
    if cookies[:comparator].nil?
      cookies.permanent.signed[:comparator] = Comparator.generate_comp_token
    end
  end

  def self.generate_comp_token(model_class = Comparator)
        loop do
          token = "#{Comparator.random_token}#{Comparator.unique_ending}"
          break token unless model_class.exists?(comp_token: token)
        end
  end
  def self.random_token
    SecureRandom.urlsafe_base64(nil, false)
  end

  def self.unique_ending
    (Time.now.to_f * 1000).to_i
  end

  def populate(product)
    self.clean
    products = Spree::Product.joins(:taxons)
                             .where(taxons: {id: product.depthest_taxon}, 
                                    deleted_at: nil)
    products.each do |product|
      self.variants << product.master if product.comparable_attrs.any?
    end
  end

  def clean
    self.items.destroy_all
  end

  def attributes_names
    self.variants.each do |variant|
      if variant.product.comparable_attrs.any?
        return variant.product.comparable_attrs.pluck(:'comparable_attributes.name' )
      end
    end
    return []
  end
end
