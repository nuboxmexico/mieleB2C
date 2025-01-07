# Deface::Override.new(virtual_path: 'spree/admin/products/_form',
#   name: 'add_sale_price_to_product_edit',
#   insert_after: "erb[loud]:contains('text_field :price')",
#   text: "
#       <div data-hook='admin_product_form_price'>
# 	    <%= f.field_container :offer_price, class: ['form-group'] do %>
# 	      <%= f.label :offer_price, raw(Spree.t(:offer_price) + content_tag(:span, ' *')) %>
# 	      <%= f.text_field :offer_price, value: number_to_currency(@product.master.prices[0].offer_price, unit: ''), class: 'form-control', disabled: (cannot? :update, @product.master.prices[0].offer_price) %>
# 	      <%= f.error_message_on :offer_price %>
# 	    <% end %>
# 	  </div>
#   ")