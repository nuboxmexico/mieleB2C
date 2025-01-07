class AddToCart extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        btns_action_class: "row",
        btns_variants_class: "hidden"
      };
    this.handleAddToCart = this.handleAddToCart.bind(this);
    this.handleAddToComparator = this.handleAddToComparator.bind(this);
    this.handleVariantClick = this.handleVariantClick.bind(this);
  }
  handleAddToCart(event) {
    event.preventDefault();
      if(this.props.item.variants.length > 0){
        this.setState({
          btns_action_class: "hidden",
          btns_variants_class: "row"
        });
      }else{
    		addProductToCart(this.props.item.id,this.props.item.id);
  	  }
	 }
  handleAddToComparator(event){
    event.preventDefault();
    if(this.props.item.variants.length > 0){
      this.setState({
        btns_action_class: "hidden",
        btns_variants_class: "row"
      });
    }else{
      addProductToComparator(this.props.item.id);
    }
  }
  handleVariantClick(event){
    event.preventDefault();
    this.setState({
          btns_action_class: "row",
          btns_variants_class: "hidden"
        });
    addProductToCart(event.target.id, "variant");
  }   
  render() {
  	const class_action = this.props.item.id+"-action";
    const class_btn = "btn btn-tertiary-sm product-"+ class_action;
    const id_variants ="product-"+this.props.id+"-variants";
    const id_btn ="add-to-cart-button"+this.props.item.id;
    const btn_details_url ="/products/"+this.props.item.slug;
    const variants = [];
    var i = 0;
	if(this.props.item.variants.length > 0){
  		this.props.item.variants.forEach((variant) => {
  		var btn_variant_id = variant.id;
    	if(variant.option_values.length > 0){
	        if (i < 3){
	          variants.push(
      				<Variant
                key={variant.id}
                variant= {variant}
                btn_variant_id={btn_variant_id}
                onhandleVariantClick= {this.handleVariantClick}
              />
	          );
	        }
        	else if (i==4){
        		variants.push(
        			<a key={this.props.item.id+"all"} href={btn_details_url} target="_blank" className="btn btn-tertiary-sm variant-option" >Ver todas las variantes</a>
	            );
        	}
    	}
        i = i+1;
      });
    }	
    return (
      <a href={btn_details_url} 
         className="btn btn-primary mdl-button mdl-js-button mdl-button--raised" >  
        Ver detalles    
      </a>
    );
  }
}