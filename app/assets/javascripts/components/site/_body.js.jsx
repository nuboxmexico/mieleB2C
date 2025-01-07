class Body extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      filterText: '',
      items: [],
      loader: 'hidden',
      search: false,
      taxon_id: "",
      taxon_name: "",
      total_pages: 0,
      total_items: 0,
      current_page: 1,
      order_criteria: "",
      select_brands: []
    };
    this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
    this.handleLoader = this.handleLoader.bind(this);
    this.handleSearch = this.handleSearch.bind(this);
    this.handleTaxonChange = this.handleTaxonChange.bind(this);
    this.handePageChange = this.handePageChange.bind(this);
    this.handleCriteriaChange = this.handleCriteriaChange.bind(this);
    this.handleFilterBtn = this.handleFilterBtn.bind(this);
    this.handleBrandSelectChange = this.handleBrandSelectChange.bind(this);
  }
  componentDidMount() {
    var url_string = window.location.href; //window.location.href
    var url = new URL(url_string);
    if(window.location.pathname.includes("/t/")){ 
      var taxon_friendly = window.location.pathname.replace("/t/", "").replace("/es", "");
      $.getJSON('/taxons/get_taxon.json?utf8=✓&id='+ taxon_friendly, (response) => {
          this.handleTaxonChange(response.id,response.name);    
      });
    }
    if (url.searchParams != undefined){
      var filterText_t = url.searchParams.get("keywords");
      if (filterText_t!=null){
          this.handleFilterTextChange(filterText_t);
      }
    }
  }
  handleFilterTextChange(filterText) {
    //scroll_to_anchor("main_body");
    this.handleLoader(true);
    this.handleSearch(true);
    this.setState({
      filterText: filterText
    });
    if(filterText != ""){
      $.getJSON('/products.json?utf8=✓&keywords='+ filterText+ "&taxon="+this.state.taxon_id+"&page="+this.state.current_page+"&order_criteria="+this.state.order_criteria+"&brand_any="+this.state.select_brands, (response) => { this.setState({ items: JSON.parse(response["products"]), total_pages: response["total_pages"], current_page: response["current_page"], total_items: response["total_items"]}) });
    }else{
      this.setState({
        items: []
      });
      this.handleLoader(false);
      this.handleSearch(false);
    }

  }
  handleLoader(loader_t){
    if(loader_t){
      this.setState({
        loader: "row"
      });
    }else{
      this.setState({
        loader: "hidden"
      });
    }
  }
  handleSearch(search_t){
    if(search_t){
      this.setState({
        search: true
      });
    }else{
      this.setState({
        search: false
      });
      //this.refs.search.refs.search_input.focus();
    } 
  }
  handleTaxonChange(taxon_id,taxon_name, permalink){
    scroll_to_anchor("main_body");
    this.handleLoader(true);
    this.setState({
      taxon_id: taxon_id,
      taxon_name: taxon_name
    });

    if(permalink != null){
      window.history.replaceState("", "", "/t/"+permalink);
    }
    if(taxon_name != null){
      $(document).prop('title', taxon_name);
    }
    if(taxon_id != ""){
      $.getJSON('/products.json?utf8=✓&keywords='+ this.state.filterText+ "&taxon="+taxon_id+"&page="+this.state.current_page+"&order_criteria="+this.state.order_criteria+"&brand_any="+this.state.select_brands, (response) => {
        this.setState({ items: JSON.parse(response["products"]), total_pages: response["total_pages"], current_page: response["current_page"], total_items: response["total_items"]})
      });
    }else{
      this.setState({
        items: []
      });
      this.handleLoader(false);
    }
  }
  handePageChange(current_page_t){
    scroll_to_anchor("main_body");
    this.handleLoader(true);
    this.setState({
      current_page: current_page_t
    });
    if(current_page_t != 0){
      $.getJSON('/products.json?utf8=✓&keywords='+ this.state.filterText+ "&taxon="+this.state.taxon_id+"&page="+current_page_t+"&order_criteria="+this.state.order_criteria+"&brand_any="+this.state.select_brands, (response) => {
        this.setState({ items: JSON.parse(response["products"])})
      });
    }else{
      this.setState({
        items: []
      });
      this.handleLoader(false);
    }
  }
  handleCriteriaChange(e){
    this.setState({order_criteria: e.target.value});
    if(this.state.items.length > 0){
      this.handleLoader(true);
      $.getJSON('/products.json?utf8=✓&keywords='+ this.state.filterText+ "&taxon="+this.state.taxon_id+"&page="+this.state.current_page+"&order_criteria="+e.target.value+"&brand_any="+this.state.select_brands, (response) => {
          this.setState({ items: JSON.parse(response["products"])})
          this.handleLoader(false);
      });
    }
  }
  handleFilterBtn(){
    if($("#brands").is(":visible")){
      $("#brands").hide("slow");
      $("#content-products").addClass("col-sm-12");
      $("#content-products").removeClass("col-sm-9");
      $("#btn-icon").removeClass("fa-chevron-left");
      $("#btn-icon").addClass("fa-chevron-right");
    }
    else{
      $("#brands").show("slow");
      $("#content-products").removeClass("col-sm-12");
      $("#content-products").addClass("col-sm-9");
      $("#btn-icon").removeClass("fa-chevron-right");
      $("#btn-icon").addClass("fa-chevron-left");
    }
  }
  handleBrandSelectChange(e){
    var new_brands = this.state.select_brands;
    if(this.state.select_brands.includes(e.target.value)){
      if(e.target.checked == false){
        new_brands.filter(i => i !== e.target.value);
      }  
    }else{
      if(e.target.checked){
        new_brands.push(e.target.value);
      } 
    }
    this.setState({ select_brands: new_brands });
    this.handleLoader(true);
    $.getJSON('/products.json?utf8=✓&keywords='+ this.state.filterText+ "&taxon="+this.state.taxon_id+"&page="+this.state.current_page+"&order_criteria="+this.state.order_criteria+"&brand_any="+new_brands, (response) => {
        this.setState({ items: JSON.parse(response["products"])})
        this.handleLoader(false);
    });
  }
  render() {
    const nav_pag = [];
    const nav_order = [];
    var showing_items = '-';
    var total_items = '-';
    if (this.state.total_pages > 0){
      nav_pag.push(
          <Navigation
            key="nav_pag" 
            total_pages={this.state.total_pages}
            current_page={this.state.current_page}
            onhandePageChange={this.handePageChange}
          />
        );
    }
    if(this.state.items.length > 0){
      nav_order.push(
          <div className="" key="order_criteria">   
            <div className="form-group showbox-react" style={{float: "right",clear: "both",display: "flex"}}>
              <select className="form-control" onChange={this.handleCriteriaChange} selected={this.state.order_criteria}>
                <option value="">Ordenar por</option>
                <option value="1">Mayor precio</option>
                <option value="2">Mayor descuento</option>
                <option value="3">Menor precio</option>
                <option value="4">Menor descuento</option>
                <option value="5">A -- Z</option>
                <option value="6">Z -- A</option>
              </select>
            </div>
          </div>
      );
      showing_items = this.state.items.length;
      total_items = this.state.total_items;
    }
    return (
    <div>
      
      <TaxonNavMobile 
            onhandleTaxonChange={this.handleTaxonChange}
            taxon_name={this.state.taxon_name}
            taxon_id={this.state.taxon_id}
            filterText={this.state.filterText}
            search={this.state.search}
            onFilterTextChange={this.handleFilterTextChange}
            onhandleSearch={this.handleSearch}
      />
      <Loader
          loader={this.state.loader}
        />
      <div className="row container-fluid-custom">
          <div id="content-products">
            <AllProducts 
              products={this.state.items}
              onhandleLoader= {this.handleLoader}
              filterText={this.state.filterText}
              loader={this.state.loader}
              sectionTitle="Resultados de la búsqueda"
            />
          </div>
      </div>
    </div>
    )
  }
}