module Spree
  class Promotion
    module Actions
      class MieleAdjustment < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::MieleFlatPercentItemTotal.new }

        def perform(options = {})
          order = options[:order]
          create_unique_adjustment(order, order)
        end

        def compute_amount(order)
          [(order.item_total + order.ship_total), compute(order)].min * -1
        end
      end
    end
  end
end
