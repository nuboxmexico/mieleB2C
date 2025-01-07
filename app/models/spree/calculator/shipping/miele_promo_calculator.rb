require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class MielePromoCalculator < ShippingCalculator

#SIGUIENTE DOS MÉTODOS SON LOS MÍNIMOS PARA QUE FUNCIONE LA NUEVA CALCULADORA

      def self.description
        return 'Promo RM despacho Miele'
      end


      def compute_package(package)
        # Returns the value after performing the required calculation
        shipping_region = package.order.try(:ship_address).try(:state).try(:abbr)
        return 0 unless shipping_region
        if shipping_region == 'RM'
          return 0
        else
          return compute_from_address(package.order, shipping_region)
        end
      end

# DE ACÁ PARA ABAJO SE HACEN LOS DISTINTOS CÁLCULOS RELATIVOS


      def compute_from_address(order, shipping_region)
        cost = 0

        line_items = order.line_items.select{|l| !l.variant.product.service}
        with_instalation = line_items.select{|l| l.variant.product.specific_attribute.instalation}
                                   .map{|l| l.quantity}
                                   .reduce(:+)
        cost += with_instalation_cost(with_instalation, shipping_region).to_i
        if shipping_region == 'RM'
          line_items = line_items.select{|l| !l.variant.product.specific_attribute.instalation}
        end

        cost += without_instalation_cost(line_items, shipping_region).to_i

        cost += pai_cost(order, shipping_region).to_i
        return cost
      end

      def with_instalation_cost(products_quantity, shipping_region)
        case products_quantity
          when 1
            return 44900 * products_quantity
          when 2..5
            return 39900 * products_quantity
          when 6..Float::INFINITY
            return 34900 * products_quantity
        end
      end

      def without_instalation_cost(line_items, shipping_region)
        cost = 0
        mda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'MDA'}
                                 .map{|l| l.quantity}
                                 .reduce(:+)
        cost += mda_cost(mda_products.to_i, shipping_region)

        sda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'SDA'}
                                 .map{|l| l.quantity}
                                 .reduce(:+)
        cost += sda_cost(sda_products.to_i, shipping_region)

        return cost
      end

      def mda_cost(products_quantity, region, base_price=9900)
        if region == 'RM'
          preturn base_price * products_quantity
        else
          case products_quantity
            when 1
              return 49900 * products_quantity
            when 2..5
              return 44900 * products_quantity
            when 6..Float::INFINITY
              return 39900 * products_quantity
            else
              return 0
          end
        end
      end

      def sda_cost(products_quantity, region, base_price=5900)
        if region == 'RM'
          return base_price * products_quantity
        else
          case products_quantity
            when 1
              return (base_price + 24900) * products_quantity
            when 2..5
              return (base_price + 21900) * products_quantity
            when 6..Float::INFINITY
              return (base_price + 18900) * products_quantity
            else
              return 0
          end
        end
      end

      def pai_cost(order, region, base_price=5900)
        pai_items = order.line_items.select{|l| (!l.variant.product.service and l.variant.product.specific_attribute.category == 'PAI')}
        if pai_items.any? 
          if region == 'RM'
            return base_price
          else
            pai_total = pai_items.map{|l| l.price * l.quantity}
                                 .reduce(:+)
            return base_price + pai_total * 0.05
          end
        end
      end

    end
  end
end