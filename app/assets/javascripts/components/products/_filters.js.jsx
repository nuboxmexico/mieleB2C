class Filters extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      brands: [],
      select_brands: []
    };
    this.handleBrandChange = this.handleBrandChange.bind(this);
  }
  componentDidMount() {
    $.getJSON('/products/brands.json', (response) => { this.setState({ brands: response })});
  }
  handleBrandChange(e){
    this.props.handleBrandSelectChange(e);
  } 
  render() {
    const items = [];
    if(this.state.brands.length > 0){
      this.state.brands.forEach((brand) => {
        items.push(
          <li className="list-group-item" key={brand}>
            <input className="checkbox-custom" id ={brand} onChange={this.handleBrandChange} type="checkbox" value={brand}/>
            <label className="checkbox-custom-label" htmlFor={brand}>&nbsp;&nbsp;{brand}</label>
          </li>
        );
      });
    }
    return (
      <div>
        <div id= "brands" className="">
          <div className="box-body">
            <ul className="form-group list-group">
             <li className="list-group-item">
              <b className="box-title">Marcas</b>
              </li>
              {items}
            </ul>
          </div>
        </div>
      </div>
    );
  }
}
