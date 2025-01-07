class DiscountBadge extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
  	const items = [];
    if(this.props.discount > 0){
    	items.push(
        	<div key={this.props.item.id} className="discount-badge-inner">
	            <svg width="85%" height="35px" viewBox="125 137 50 25" version="1.1" x="0px" y="0px" >
	                <defs></defs>
	                <g id="Etiqueta-descuento" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd" transform="translate(125.000000, 137.000000)">
	                    <path d="M10,3 L50,3 L50,23.0012539 C50,23.5528461 49.5507812,24 48.9912248,24 L10,24 L10,3 Z M1.37995811,14.948956 C0.617828291,14.1487197 0.617998186,12.8511019 1.37995811,12.051044 L10,3 L10,24 L1.37995811,14.948956 Z" id="Combined-Shape" fill="#cc0000"></path>
	                    <polygon id="Path-2" fill="#AF2B2B" points="46.0435791 3 46.0435791 0.0420302541 49.9989014 3"></polygon>
	                    <text id="discount-number" fontSize="12" fontWeight="bold" fill="#FFFFFF">
	                        <tspan x="12.3261719" y="17">{this.props.discount}%</tspan>
	                    </text>
	                </g>
	            </svg>
          	</div>

        );        
    }else{
    	items.push(
    		<div key={this.props.item.id} align="right">
            	<svg width="85%" height="35px" viewBox="125 137 50 25" version="1.1">
            	</svg>
      		</div>
		);
    }
    return (
      	<div className="discount-badge" align="right">
        	{items}  
        </div>
    );
  }
}
