Deface::Override.new(virtual_path: 'spree/admin/products/_form',
  name: 'add_product_id_to_product_edit',
  insert_after: "erb[loud]:contains('text_field :cost_price')",
  text: "<%= hidden_field_tag 'product_id', @product.id %>")