class AddTaxonReferencesToPromotionalBanner < ActiveRecord::Migration
  def change
    add_reference :promotional_banners, :spree_taxon, index: true, foreign_key: true
  end
end
