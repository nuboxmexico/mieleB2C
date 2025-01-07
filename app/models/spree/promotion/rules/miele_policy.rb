module Spree
  class Promotion
    module Rules
      class MielePolicy < PromotionRule
        preference :amount_min, :decimal, default: 100.00
        preference :operator_min, :string, default: '>'
        preference :amount_max, :decimal, default: 1000.00
        preference :operator_max, :string, default: '<'


        OPERATORS_MIN = ['gt', 'gte']
        OPERATORS_MAX = ['lt','lte']

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          item_total = order.total_without_products_in_offer

          lower_limit_condition = item_total.send(preferred_operator_min == 'gte' ? :>= : :>, BigDecimal.new(preferred_amount_min.to_s))
          upper_limit_condition = item_total.send(preferred_operator_max == 'lte' ? :<= : :<, BigDecimal.new(preferred_amount_max.to_s))

          eligibility_errors.add(:base, ineligible_message_max) unless upper_limit_condition
          eligibility_errors.add(:base, ineligible_message_min) unless lower_limit_condition
          # eligibility_errors.add(:base, 'La suma de descuentos de precios ofertas es mayor que la de la promoción') unless promotion_better_than_offer_prices?(order)

          eligibility_errors.empty?
        end

        private
        def formatted_amount_min
          Spree::Money.new(preferred_amount_min).to_s
        end

        def formatted_amount_max
          Spree::Money.new(preferred_amount_max).to_s
        end


        def ineligible_message_max
          if preferred_operator_max == 'gte'
            eligibility_error_message(:item_total_more_than_or_equal, amount: formatted_amount_max)
          else
            eligibility_error_message(:item_total_more_than, amount: formatted_amount_max)
          end
        end

        def ineligible_message_min
          if preferred_operator_min == 'gte'
            eligibility_error_message(:item_total_less_than, amount: formatted_amount_min)
          else
            eligibility_error_message(:item_total_less_than_or_equal, amount: formatted_amount_min)
          end
        end

        def promotion_better_than_offer_prices?(order)
          return (promotion_discount(without_product_offers(order)).abs > offer_prices_discount(order).abs)
        end

        def offer_prices_discount(order)
          return order.total_without_product_offers - order.amount
        end

        def promotion_discount(order)
          return promotion.actions.map{|action| action.calculator.compute(order)}.sum
        end

        def without_product_offers(order)
          new_order = Spree::Order.new
          new_order.item_total = order.item_total
          new_order.ship_total = order.ship_total
          new_line_items = order.line_items.map do |line_item| 
            new_line_item = line_item.dup
            new_line_item.price = line_item.variant.price
            new_line_item
          end
          new_order.line_items << new_line_items
          return new_order
        end
      end
    end
  end
end
