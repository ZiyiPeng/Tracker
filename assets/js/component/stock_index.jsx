import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import Chart from 'chart.js';


function StockIndex(props) {
  return (
    <div className="ui-widget">
      <input id="autocomplete" onInput={()=>search()}></input>
      <button id="search-submit" onClick={()=>perform_search()}></button>
    </div>
  );
}

function RenderStat(props) {
  console.log(props)
  let stat = props.stats;
  return (
  <div>
    <ul>
      <li>beta: {stat.beta}</li>
      <li>return: {stat.rate_of_return}%</li>
      <li>risk: {stat.risk}%</li>
    </ul>
  </div>);
}

function perform_search() {
  let input = document.getElementById("autocomplete").value;
  api.prepare_stock(input);
}

function get_suggestsions(input){
  $.ajax(`http://localhost:4000/api/stock_search?input=${input}`, {
  method: "get",
  dataType: "json",
  contentType: "application/json; charset=UTF-8",
  success: (resp) => {
    let option = _.map(resp["best_matches"], function(e) {
      return {label: e["1. symbol"] + " (" + e["2. name"] + ")", value: e["1. symbol"]}
    });
    $( "#autocomplete" ).autocomplete({
      source: option
    });
  },
  });
}

function search() {
  let input = document.getElementById("autocomplete").value;
  get_suggestsions(input);
}


function state2props(state) {
  console.log("rerender", state);
  return {
    portfolio: state.portfolio,
    stock: state.current_stock
  };
}

// Export result of curried function call.
export default connect(
  state2props
)(StockIndex);
