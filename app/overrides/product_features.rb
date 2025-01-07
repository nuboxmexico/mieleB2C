Deface::Override.new(virtual_path: 'spree/admin/products/_form',
  name: 'add_feature_to_product_edit',
  insert_after: "erb[loud]:contains('text_field :cost_price')",
  text: "
      <div data-hook='admin_product_form_feature'>
	    <%= f.field_container :featured, class: ['form-group'] do %>
	      <%= f.label :featured, raw(Spree.t(:featured) + content_tag(:span, ' *')) %>
	      <%= f.check_box :featured, value: @product.featured, class: 'form-control' %>
	      <%= f.error_message_on :featured %>
	    <% end %>
	  </div>
	  <div data-hook='admin_product_form_feature'>
	    <%= f.field_container :service, class: ['form-group'] do %>
	      <%= f.label :service, raw(Spree.t(:service) + content_tag(:span, ' *')) %>
	      <%= f.check_box :service, value: @product.service, class: 'form-control' %>
	      <%= f.error_message_on :service %>
	    <% end %>
	  </div>
  ")