import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;


function Company(props) {
  //api.get_company(props.stock.abbreviation);
  var body = "";
  let company = props.company;
  if(company) {
    body =<div class="card">
    <img class="card-img-top" src={company.logo} style={{}}></img>
    <div class="card-body">
      <h5 class="card-title">{company.company_name}</h5>
      <p class="card-text">{company.description}</p>
    </div>
    <ul class="list-group list-group-flush">
      <li class="list-group-item">CEO: {company.ceo}</li>
      <li class="list-group-item">Sector: {company.sector}</li>
      <li class="list-group-item">Website: {company.website}</li>
    </ul>
  </div>;

  }




  return (
    <div>
      {body}
      <Link to={"/stock"}>Back</Link>
    </div>
  );
}

function state2props(state) {
  return {
    stock: state.current_stock,
    company: state.company,
  };
}

// Export result of curried function call.
export default connect(
  state2props
)(Company);
