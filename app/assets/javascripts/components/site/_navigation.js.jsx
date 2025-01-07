class Navigation extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(e){
    e.preventDefault();
    var page_t = 0
    if(e.target.id == "first"){
    	page_t = 1
    }else if(e.target.id == "last"){
    	page_t = this.props.total_pages;
    }else{
    	page_t = e.target.id.split("-")[1];
    }
    this.props.onhandePageChange(page_t);
  }  

  render() {
  	const items = [];
    if(this.props.total_pages > 0){
  		for (var i = 1; i < (this.props.total_pages+1); i++) {
  			var item_class= ""
  			if (i == this.props.current_page){
  				item_class = "active"
  			}
	        items.push(
  				<li key={"page"+i} className={"page-item "+item_class}><a className="page-link" onClick={this.handleChange.bind(this)} href="#" id={"page-"+ i}>{i}</a></li>
        	);
		}
	//<li className="page-item active"><a className="page-link" href="#">2</a></li>
	}else if(this.props.filterText != "" && this.props.loader== "hidden"){
      items.splice(0,items.length)
      items.push(
          <div key={"no-product-key"} className="alert alert-danger">No se han encontrado resultados...</div>
      );
    }
    return (
		<div align="center">
			<ul className="pagination border-0 margin-0">
			  <li className="page-item disabled"><a className="page-link" onClick={this.handleChange.bind(this)} href="#" id="first"><i className="fa fa-step-backward hidden-sm hidden-md hidden-lg"></i><span className="hidden-xs"> Primera</span></a></li>
			  {items}
			  <li className="page-item"><a className="page-link" onClick={this.handleChange.bind(this)} href="#" id="last"><span className="hidden-xs">Última </span><i className="fa fa-step-forward hidden-sm hidden-md hidden-lg"></i></a></li>
			</ul>
		</div>		    
    );
  }
}
