require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class MieleDispatchAndInstallationCalculator < ShippingCalculator
      def self.description
        return 'Política Despacho e Instalación abril 2022'
      end

      def compute_package(package)
        shipping_region = package.order.try(:ship_address).try(:state)
          return 0 unless shipping_region
        return calculate_dispatch_value(package.order, shipping_region)
      end

      def calculate_dispatch_value(order, shipping_region)

          mda_dispatch_type = mda_dispatch_type_checker(order.line_items)
          mda_q_1 = mda_q(order.line_items)
          mda_dispatch_value = mda_dispatch_type == 0 ? 0 : shipping_region[mda_dispatch_type] 

          sda_dispatch_type = sda_dispatch_type_checker(order.line_items)
          sda_q_1 = sda_q(order.line_items)
          sda_dispatch_value = sda_dispatch_type == 0 ? 0 : shipping_region[sda_dispatch_type]
          
          if mda_q_1 > 0 || sda_q_1 > 0
            pai_value = 0
          else
            pai_dispatch_type = pai_dispatch_type_checker(order.line_items)
            pai_value = pai_dispatch_type == 0 ? 0 : shipping_region[pai_dispatch_type]
          end

          return (mda_dispatch_value * mda_q_1) + (sda_dispatch_value * sda_q_1) + pai_value
      end

# REFACTORIZAR 
      def mda_q(line_items)
        #ok
        mda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'MDA'}
                                     
        if mda_products.count.nil?
          return 0
        else
          return mda_products.count
        end
      end

      def sda_q(line_items)
        sda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'SDA'}
                                    

        if sda_products.count.nil?
          return 0
        else
          return sda_products.count
        end
      end

      def pai_q(line_items)
        pai_items = line_items.select{|l| (!l.variant.product.service and l.variant.product.specific_attribute.category == 'PAI')}
        if pai_products.count
          return 0
        else
          return pai_products.count
        end
      end

      def mda_dispatch_type_checker(line_items)
        mda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'MDA'}.count
                               
                              case mda_products
                                when 1
                                  return "mda_a"                                 
                                when 2..5
                                  return "mda_b"                            
                                when 6..Float::INFINITY
                                  return "mda_c"
                                else
                                  return 0
                              end
      end
      
      def sda_dispatch_type_checker(line_items)
        sda_products = line_items.select{|l| l.variant.product.specific_attribute.category == 'SDA'}.count

                              if sda_products == 0
                                return 0
                              else
                                case sda_products
                                  when 1
                                   return "sda_a"
                                  when 2..5
                                    return "sda_b"
                                  when 6..Float::INFINITY
                                    return "sda_c"
                                end
                              end
                              
      end
      
      def pai_dispatch_type_checker(line_items)
        pai_items = line_items.select{|l| (!l.variant.product.service and l.variant.product.specific_attribute.category == 'PAI')}.count
            if pai_items > 0
              return "pai_a"
            else
              return 0
            end
      end

    end
  end
end