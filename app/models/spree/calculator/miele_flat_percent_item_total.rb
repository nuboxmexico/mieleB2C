require_dependency 'spree/calculator'

module Spree
  class Calculator::MieleFlatPercentItemTotal < Calculator
    preference :flat_percent, :decimal, default: 0

    def self.description
      Spree.t(:miele_flat_percent)
    end

    def compute(object)
      total = object.total_without_products_in_offer
      computed_amount  = (total * preferred_flat_percent / 100).round(2)

      # We don't want to cause the promotion adjustments to push the order into a negative total.
      if computed_amount > object.amount
        object.amount
      else
        computed_amount
      end
    end
  end
end
