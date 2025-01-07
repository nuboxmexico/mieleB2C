Deface::Override.new(
  virtual_path: 'spree/admin/relation_types/index',
  name: 'insert_item_extain_in_admin_relation_types',
  insert_before: "table#listing_relation_types" ,
  text: "
      <small>
      <%= t :admin_explain_relation_types_index%>
	  </small>
	  <br><br>
  "
  )

Deface::Override.new(
  virtual_path: 'spree/admin/relation_types/index',
  name: 'insert_item_extain_in_admin_relation_types_not_found',
  insert_before: "div.alert.alert-warning.no-objects-found" ,
  text: "
      <small>
      <%= t :admin_explain_relation_types_index%>
	  </small>
	  <br><br>
  "
  )
