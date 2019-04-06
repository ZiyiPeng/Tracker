import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import Chart from 'chart.js';


function StockIndex(props) {
  var stock = "";
  var add_record_form = "";
  if(props.stock) {
    try{
      render_graph(props.stock);
      stock = RenderStockStat(props);
      add_record_form = RenderRecordForm(props);
    }
    catch(err){}
  }
  return (
    <div>
      <div className="ui-widget">
        <input id="autocomplete" onInput={()=>search()}></input>
        <button id="search-submit" onClick={()=>perform_search()}>search</button>
      </div>
      <div>
        <select id="time-select" onChange={()=>render_graph(props.stock)}>
           <option value="5min">5 min interval</option>
           <option value="15min">15 min interval</option>
           <option value="30min">30 min interval</option>
           <option value="60min">60 min interval</option>
           <option value="1d">1 day</option>
           <option value="3m">3 month</option>
           <option value="6m">6 month</option>
           <option value="1y">1 year</option>
           <option value="2y">2 year</option>
        </select>
        <canvas id="stock-history-chart" width="800" height="450"></canvas>
      </div>
      <div id="stock-stat">
        {stock}
      </div>
      <div>
        {add_record_form}
      </div>
    </div>
  );
}

function RenderStockStat(props) {
  let stat = props.stock;
  return (
  <div>
    <ul>
      <li>company: {stat.name}</li>
      <li>abbreviation: {stat.abbreviation}</li>
      <li>beta: {stat.beta}</li>
      <li>risk: {stat.risk}%</li>
      <li>return: {Math.round(stat.rate_of_return * 100*100)/100}%</li>
    </ul>
  </div>);
}

function RenderRecordForm(props) {
  let stock = props.stock;
  let price = window.stock_price;
  return (
    <div>
      <p>quantity: <input id="quantity" placeholder='0' onInput={()=>update_amount()}></input></p>
      <p>purchase price: <input id="purchase_price" placeholder='0' onInput={()=>update_amount()}></input></p>
      <p>total: <input id="amount" readOnly="readonly"></input></p>
      <button id="add-record-submit" onClick={()=>add_record(props)}>submit</button>
    </div>
  );
}

function add_record(props) {
  let quantity = document.getElementById("quantity").value;
  let price = document.getElementById("purchase_price").value;
  let result = Math.round(parseFloat(quantity)*parseFloat(price)*100)/100
  let portfolio_id = props.portfolio.id;
  let abbreviation = props.stock.abbreviation;
  console.log({"amount": result, "purchased_price": price, "quantity": quantity, "abbreviation": abbreviation, "portfolio_id": portfolio_id});
  api.add_record(
    {"amount": result, "purchased_price": price, "quantity": quantity, "abbreviation": abbreviation, "portfolio_id": portfolio_id}
  );
}

function update_amount() {
  let quantity = document.getElementById("quantity").value;
  let price = document.getElementById("purchase_price").value;
  let result = Math.round(parseFloat(quantity)*parseFloat(price)*100)/100
  $("#amount").val(result.toString());
}

function perform_search() {
  let input = document.getElementById("autocomplete").value;
  api.prepare_stock(input);
}

function render_graph(stock) {
  if(stock) {
    let time = document.getElementById("time-select").value;
    let stock_abbrev = document.getElementById("autocomplete").value;
    if(["5min", "15min", "30min", "60min"].includes(time)) {
      render_intraday(stock_abbrev, time);
    }
    else {
      render_stock_history(stock_abbrev, time);
    }
  }
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

function render_intraday(abbrev, time) {
  $.ajax(`http://localhost:4000/api/stock_intraday?abbreviation=${abbrev}&time-span=${time}`, {
  method: "get",
  dataType: "json",
  contentType: "application/json; charset=UTF-8",
  success: (resp) => {
    let dates = _.map(Object.keys(resp["prices"]), function(x){return x.split(' ')[1]});
    let data = _.map(resp["prices"], function(x){return x["4. close"]});
    linear_graph("stock-history-chart", abbrev, dates, data)
  },
  });
}

function linear_graph(canvas_id, abbrev, x_array, y_array) {
  if(window.chart){window.chart.destroy()};
  window.chart = new Chart(document.getElementById(canvas_id), {
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
        text: 'stock value'
      }
    }
  });
}

function search() {
  let input = document.getElementById("autocomplete").value;
  get_suggestsions(input);
}


function state2props(state) {
  return {
    portfolio: state.portfolio,
    stock: state.current_stock
  };
}

// Export result of curried function call.
export default connect(
  state2props
)(StockIndex);
