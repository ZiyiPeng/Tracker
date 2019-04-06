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
    body =<ul>
            <li>ceo: {company.ceo}</li>
            <li>name: {company.company_name}</li>
            <li>description: {company.description}</li>
            <li>website: {company.description}</li>
            <li>sector: {company.sector}</li>
            <img src={company.logo}></img>
          </ul>;
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
