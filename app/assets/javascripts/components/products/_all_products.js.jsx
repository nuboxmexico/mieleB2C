class AllProducts extends React.Component {
  constructor(props) {
    super(props);
  }
  componentWillReceiveProps(nextProps) {
    // Acciones que se deben realizar cuando esta por recibir datos
  }
  componentWillUpdate(nextProps, nextState){
    // Acciones a realizar cuando se va a actualizar el componente 
    // (cambia el valor de un state)
     if(this.props.loader == "row"){
      this.props.onhandleLoader(false);
    }
  }
  componentDidUpdate(nextProps, nextState){
    // Acciones a realizar cuando el componente se ha actualizado  
  }
  render(){
    const items = [];
    if(this.props.products.length > 0){
      this.props.products.forEach((item) => {
        items.push(
          <Product
            key={"product-"+item.id}
            item={item} 
            filterText={this.props.filterText} 
          />
        );
      });
			//var items= this.state.items.map((item) => <Product item={item} filterText={this.props.filterText} />);
		}
    else if(this.props.filterText != "" && this.props.loader== "hidden"){
      items.splice(0,items.length)
      items.push(
          <div key={"no-product-key"} className="alert alert-danger">No se han encontrado resultados...</div>
      );
    }
    return(
      <div>
        <h1>{this.props.sectionTitle}</h1>
        <div id="products-container" className="col-xs-12 col-md-10 col-md-offset-1">
            {items}
        </div>
      </div>
    )
	} 
}
