class SpecificAttribute < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'spree_product_id'

  def show?
    return (self.built_in or
            self.features or
            self.features or
            self.specs or
            self.specs or
            self.technical_specs or
            self.technical_specs or
            self.product_functions or
            self.product_functions or
            self.drink or
            self.drink or
            self.basket_design or
            self.basket_design or
            self.wash_program or
            self.wash_program or
            self.dry_program or
            self.dry_program or
            self.care or
            self.care or
            self.security or
            self.security or
            self.sustain or
            self.sustain or
            self.accessories or
            self.accessories or 
            self.product.technical_documents.count > 0)
  end
end
