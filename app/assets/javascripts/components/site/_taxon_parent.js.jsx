class TaxonParent extends React.Component {
  constructor(props) {
    super(props);
    this.handleTaxonChange = this.handleTaxonChange.bind(this);
  }
  handleTaxonChange(e){
    e.preventDefault();
    this.props.onhandleTaxonChange(e.target.id,e.target.name, this.props.taxon.root.permalink);
  }
  componentDidMount() {
    $(".amenu .category").mouseover(function(){
      $(".sub-menu").hide();
      $($(this).children(".sub-menu")).show();
    });
    $(".amenu .sub-menu").mouseout(function(){
      $(this).hide();
    });
     
  }      
  render() {
    const items = [];
    if(this.props.taxon.root.children){
      this.props.taxon.root.children.forEach((taxon) => {
        items.push(
          <TaxonChild 
            key={taxon.id}
            taxon={taxon}
            taxon_name={this.props.taxon_name}
            taxon_id={this.props.taxon_id}
            onhandleTaxonChange={this.props.onhandleTaxonChange}
          />     
        );
      });
    }
    return (
      <li className="category">
          {this.props.taxon.root.name}
          <ul className="sub-menu">
              <li className="cat_head">
                <a href="#" id={this.props.taxon.root.id} name={this.props.taxon.root.name} className="drop dropdown-toggle" onClick={this.handleTaxonChange.bind(this)}> {this.props.taxon.root.name}</a>
              </li>
              {items}
          </ul>
      </li>
    );
  }
}
