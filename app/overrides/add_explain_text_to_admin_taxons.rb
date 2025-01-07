Deface::Override.new(
  virtual_path: 'spree/admin/taxons/index',
  name: 'insert_item_extain_in_admin_taxons',
  insert_before: "div.taxon-products-view" ,
  text: "
      <small>
      <%= t :admin_explain_taxon_index%>
	  </small>
	  <br><br>
  "
  )
