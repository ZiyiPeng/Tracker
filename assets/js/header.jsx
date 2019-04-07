//adapted from Nat Tuck's lecture note
import React from 'react';
import _ from 'lodash';
import { Link, BrowserRouter as Router, Route } from 'react-router-dom';
import { connect } from 'react-redux';
import api from './api';
import Popup from 'reactjs-popup';

function Header(props) {
  let {session} = props;
  let session_info;
  if (session == null) {
    session_info =
    <div>
      <nav className="navbar navbar-expand-lg navbar-light bg-light justify-content-between sticky-top">
        <h1>Stock Project</h1>

      </nav>

        <div className="col-4 container" style={{align:'center'}}>

          <p>Username:  <input type="name" className="form-control" id="user-name" placeholder="name" value="peng"/></p>
          <p>Password:  <input type="password" className="form-control" id="password" placeholder="password" value="P@ssw0rd"/></p>

          <div>
            <div >
              <button className="btn btn-primary" id="login-b" onClick={()=>login()}>Login</button>
              


              <Popup contentStyle={{width:'20%', background:'lightblue'}} trigger={<button className="btn btn-secondary" id="signup-b"> Register </button>} modal closeOnDcumentClick>
                <div >
                  <h4 style={{textAlign:'center'}}>Sign Up</h4>
                  <p className="content">Username:      <input id="create-user-name" className="form-control" type="text" /></p>
                  <p className="content">Password:  <input id="create-user-password" className="form-control" type="password" /></p>
                  <p><Link to='/'><button className="btn btn-primary" style={{float:'right'}} onClick={() => {api.create_user();}}>Create</button></Link></p>
                </div>
              </Popup>


            </div>

          </div>
        </div>

    </div>;

    
  }
  else {
    let user = props.users.find(function(ee)
    {return ee.id == props.session.user_id;});
    api.get_portfolio(user.portfolio_id);
    api.get_portfolio_stats(user.portfolio_id)
    session_info =
    <div>
      <nav class="navbar navbar-expand-md bg-light navbar-dark sticky-top">
        <div><h1 style={{font: 'Sofia'}}>Stock Project</h1></div>
        <div className="collapse navbar-collapse" id="collapsibleNavbar">
          <ul class="navbar-nav mr-auto">
            <li className="nav-item">
              <a className="nav-link"><Link to={"/portfolio"}>Portfolio</Link></a>
            </li>
            <li className="nav-item">
              <a className="nav-link"><Link to={"/stock"}>Stock</Link></a>
            </li>
          </ul>
          <ul className="navbar-nav ml-auto">
            <li>
              <a className="nav-link"><Link to={"/"} onClick={() => api.delete_session()}>logout</Link></a>
            </li>
          </ul>
        </div>

      </nav>
    </div>
  }

  return <div>
      {session_info}
    </div>;
}

function login() {
  let name = $("#user-name").val();
  let password = $("#password").val();
  api.create_session(name, password);
}



function state2props(state) {
  return { session: state.session,
    users: state.users
  };
}

export default connect(state2props)(Header);


