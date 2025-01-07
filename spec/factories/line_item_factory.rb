FactoryBot.define do
  factory :line_item, class: Spree::LineItem do
    quantity {1}
    price { BigDecimal.new('10.00') }
    order
    currency { order.currency }
    transient do
      association :product
    end
    variant { product.master }

    after :create do |line_item|
      line_item.product.stock_items.first.update(count_on_hand: 10)
    end
  end
end