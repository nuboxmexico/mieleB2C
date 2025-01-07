class Loader extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
  		<div className={"loader-page row-nullify "+this.props.loader} align="center" id="loader-global">
          <div className="gif-loader">
          <div className="showbox showbox-react loader-box" id= "loader">
            <div className="loader" align="center">
              <svg className="circular" viewBox="25 25 50 50">
                <circle className="path" cx="50" cy="50" r="20" fill="none" strokeWidth="2" strokeMiterlimit="10"/>
              </svg>
            </div>
          </div>
           </div> 
        </div> 
    );
  }
}


