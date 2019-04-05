import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';


function CreateUserForm(props) {
  return <div>
  <h1>Register</h1>
  <p>name:      <input id="create-user-name" type="text" /></p>
  <p>password:  <input id="create-user-password" type="password" /></p>
  <p><Link to='/'><button onClick={() => {api.create_user();}}>submit</button></Link>
  </p>
  </div>
}

function state2props(state) {
  console.log("rerender", state);
  return {
  };
}


// Export result of curried function call.
export default connect(state2props)(CreateUserForm);
