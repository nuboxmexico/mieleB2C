Deface::Override.new(virtual_path: 'spree/admin/taxons/_form',
  name: 'add_feature_to_taxon_edit',
  insert_after: "erb[loud]:contains('field_container :icon')" ,
  text: "
      <div data-hook='admin_taxon_form_feature'>
	    <%= f.field_container :featured, class: ['form-group'] do %>
	      <%= f.label :featured, raw(Spree.t(:featured) + content_tag(:span, ' *')) %>
	      <%= f.check_box :featured, value: @taxon.featured, class: 'form-control' %>
	      <%= f.error_message_on :featured %>
	    <% end %>
	  </div>
  ")