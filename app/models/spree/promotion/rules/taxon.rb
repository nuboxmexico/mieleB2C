module Spree
  class Promotion
    module Rules
      class Taxon < PromotionRule
        has_many :promotion_rule_taxons, class_name: 'Spree::PromotionRuleTaxon', foreign_key: 'promotion_rule_id'
        has_many :taxons, through: :promotion_rule_taxons, class_name: 'Spree::Taxon'

        MATCH_POLICIES = %w(any all two_products three_products)
        preference :match_policy, default: MATCH_POLICIES.first

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          case preferred_match_policy
            when 'all'
              unless (taxons.to_a - taxons_in_order_including_parents(order)).empty?
                eligibility_errors.add(:base, eligibility_error_message(:missing_taxon))
              end
            when 'any'
              order_taxons = taxons_in_order_including_parents(order)
              unless taxons.any?{ |taxon| order_taxons.include? taxon }
                eligibility_errors.add(:base, eligibility_error_message(:no_matching_taxons))
              end
            when 'two_products' 
              unless products_quantity_inside_taxon(order) >= 2
                eligibility_errors.add(:base, eligibility_error_message(:insufficient_products_quantity_2))
              end
            when 'three_products' 
              unless products_quantity_inside_taxon(order) >= 3
                eligibility_errors.add(:base, eligibility_error_message(:insufficient_products_quantity_3))
              end
          end
          eligibility_errors.empty?
        end

        def actionable?(line_item)
          (!line_item.variant.product.offer_price_available? and 
           taxon_product_ids.include? line_item.variant.product_id)
        end

        def taxon_ids_string
          taxons.pluck(:id).join(',')
        end

        def taxon_ids_string=(s)
          ids = s.to_s.split(',').map(&:strip)
          self.taxons = Spree::Taxon.find(ids)
        end

        def product_ids_in_promotion(order)
          product_ids_in_order = order.line_items.map{|l| l.variant.product_id}
          return product_ids_in_order - taxon_product_ids
        end

        def products
          Spree::Product.joins(:taxons).where(spree_taxons: {id: taxons.pluck(:id)})
        end

        private

        def taxon_product_ids
          Spree::Product.joins(:taxons).where(spree_taxons: {id: taxons.pluck(:id)}).pluck(:id).uniq
        end

        def products_quantity_inside_taxon(order)
          quantity = 0
          order.line_items.each do |line_item|
            if (!line_item.variant.product.offer_price_available? and taxon_product_ids.include?(line_item.variant.product_id))
              quantity += line_item.quantity
            end
          end
          return quantity
        end

        # All taxons in an order
        def order_taxons(order)
          Spree::Taxon.joins(products: {variants_including_master: :line_items})
                      .where(spree_line_items: {order_id: order.id}).uniq
        end

        # ids of taxons rules and taxons rules children
        def taxons_including_children_ids
          taxons.inject([]){ |ids,taxon| ids += taxon.self_and_descendants.ids }
        end

        # taxons order vs taxons rules and taxons rules children
        def order_taxons_in_taxons_and_children(order)
          order_taxons(order).where(id: taxons_including_children_ids)
        end

        def taxons_in_order_including_parents(order)
          order_taxons_in_taxons_and_children(order).inject([]){ |taxons, taxon| taxons << taxon.self_and_ancestors }.flatten.uniq
        end
      end
    end
  end
end
