import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import Chart from 'chart.js';


function StockIndex(props) {
  if(props.stock) {
    console.log("has stock")
    render_graph();
  }
  return (
    <div>
      <div className="ui-widget">
        <input id="autocomplete" onInput={()=>search()}></input>
        <button id="search-submit" onClick={()=>perform_search()}>search</button>
      </div>
      <div>
        <select id="time-select">
           <option value="1d">1 day</option>
           <option value="3m">3 month</option>
           <option value="6m">6 month</option>
           <option value="1y">1 year</option>
           <option value="2y">2 year</option>
        </select>
        <canvas id="stock-history-chart" width="800" height="450"></canvas>
      </div>
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

function render_graph() {
  let time = document.getElementById("time-select").value;
  let stock_abbrev = document.getElementById("autocomplete").value;
  render_stock_history(stock_abbrev, time);
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

function render_stock_history(abbrev, time) {
  $.ajax(`http://localhost:4000/api/stock_history?abbreviation=${abbrev}&time-span=${time}`, {
  method: "get",
  dataType: "json",
  contentType: "application/json; charset=UTF-8",
  success: (resp) => {
    let dates = _.map(resp["history"], function(x){return x["date"]});
    let data = _.map(resp["history"], function(x){return x["price"]});
    linear_graph("stock-history-chart", abbrev, dates, data)
  },
  });
}

function linear_graph(canvas_id, abbrev, x_array, y_array) {
  new Chart(document.getElementById(canvas_id), {
    type: 'line',
    data: {
      labels: x_array,
      datasets: [{
        data: y_array,
        label: abbrev,
        borderColor: "#3e95cd",
        fill: false
      }]
    },
    options: {
      title: {
        display: true,
        text: 'portfolio value'
      }
    }
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
