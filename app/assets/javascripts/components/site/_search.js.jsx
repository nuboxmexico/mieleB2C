class SearchBar extends React.Component {
  constructor(props) {
    super(props);
    this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
  }
  handleFilterTextChange(e) {
    this.props.onFilterTextChange(e.target.value);
  }
  componentWillUpdate(nextProps, nextState){
    // Acciones a realizar cuando se va a actualizar el componente 
    // (cambia el valor de un state)
     if(this.props.search == true){
      this.props.onhandleSearch(false);
    }
  }
  componentDidUpdate(prevProps, prevState){
    this.refs.search_input.focus();
  }
  render() {
    return (
      <form>
        <div className="form-group">
          <div className="input-group">
            <input
              id="search_input_react"
              className="form-control search-input search-bar-right"
              type="text"
              placeholder="Buscar..."
              value={this.props.filterText}
              onChange={this.handleFilterTextChange}
              disabled={this.props.search}
              ref= "search_input"
            />
            <div className="input-group-addon search-addon">
                <i className="glyphicon glyphicon-search"></i>
            </div>
          </div>
        </div>
      </form>
    );
  }
}
