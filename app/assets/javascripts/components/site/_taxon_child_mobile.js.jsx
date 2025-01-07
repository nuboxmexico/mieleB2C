class TaxonChildMobile extends React.Component {
  constructor(props) {
    super(props);
    this.handleTaxonChange = this.handleTaxonChange.bind(this);
  }
  handleTaxonChange(e){
    e.preventDefault();
    this.props.onhandleTaxonChange(e.target.id,e.target.name, $(e.target).data('permalink'));
  }   
  render() {
    return (
      <li className="li-nav">
        <b><a href="#" id={this.props.taxon.id} name={this.props.taxon.name} data-permalink={this.props.taxon.friendly_id} onClick={this.handleTaxonChange.bind(this)}> {this.props.taxon.name}</a></b>
      </li>
    );
  }
}
