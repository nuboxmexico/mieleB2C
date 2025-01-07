class TaxonParentMobile extends React.Component {
  constructor(props) {
    super(props);
    this.handleTaxonChange = this.handleTaxonChange.bind(this);
  }
  handleTaxonChange(e){
    e.preventDefault();
    this.props.onhandleTaxonChange(e.target.id,e.target.name, this.props.taxon.permalink);
  }
  componentDidMount() {
      $('.dropdown-toggle').dropdown();
  }  
  render() {
    const items = [];
    const itemsparent=[]
    if(this.props.taxon.root.children){
      if(this.props.taxon.root.children.length > 0){
        this.props.taxon.root.children.forEach((taxon) => {
          items.push(
            <TaxonChildMobile
              key={taxon.id}
              taxon={taxon}
              taxon_name={this.props.taxon_name}
              taxon_id={this.props.taxon_id}
              onhandleTaxonChange={this.props.onhandleTaxonChange}
            />       
          );
        });
        itemsparent.push(
          <a key="{this.props.taxon.root.id}" className="drop dropdown-toggle" href="#" id={this.props.taxon.root.id} name={this.props.taxon.root.name}  data-toggle="dropdown">
            {this.props.taxon.root.name} &nbsp;
                <span className="caret"></span>
          </a> 
        );
        itemsparent.push(
            <ul key="{this.props.taxon.root.id}ul" className="dropdown-menu" id={this.props.taxon.root.name}>
           {items}    
        </ul>
        );
      }else{
        itemsparent.push(
        <a key="{this.props.taxon.root.id}" href="#" id={this.props.taxon.root.id} name={this.props.taxon.root.name} className="drop" onClick={this.handleTaxonChange.bind(this)}> {this.props.taxon.root.name}</a>
   
        );
      } 
      
    }
    return (
        <li className="dropdown li-nav">
          
          {itemsparent}
        </li>   
    );
  }
}
