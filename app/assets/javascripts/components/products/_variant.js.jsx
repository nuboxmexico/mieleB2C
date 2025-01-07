class Variant extends React.Component {
  constructor(props) {
    super(props);
  } 
  render() {
    return (
      <div>
      	<a href="#" key={this.props.variant.id+"variant"} onClick={this.props.onhandleVariantClick} className="btn btn-tertiary-sm variant-option" id={this.props.variant.id} variant={this.props.variant.id}>
            {this.props.variant.option_values[0].name}
		</a>
      </div>
    );
  }
}
