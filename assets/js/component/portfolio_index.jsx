import _ from 'lodash';
import { connect } from 'react-redux';
import React from 'react';
import api from '../api';
import { Link } from 'react-router-dom';
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import Chart from 'chart.js';
import RecordList from './recordlist'


function PortfolioIndex(props) {
  //api.get_portfolio_stats(props.portfolio.id);
  render_portfolio_history(props.portfolio.id);
  render_portfolio_composition(props.portfolio.id);
  return<div>
        <canvas id="portfolio-history-chart" width="800" height="450"></canvas>
        <canvas id="doughnut-chart" width="300" height="300"></canvas>
        <RenderStat stats={props.stats}/>
        <RecordList records={props.portfolio.records}/>
      <p><Link to='/'>back</Link></p>
  </div>
}

function RenderStat(props) {
  let stat = props.stats;
  return (
  <div>
    <ul>
      <li>beta: {stat.beta}</li>
      <li>return: {Math.round(stat.rate_of_return * 100*100)/100}%</li>
      <li>risk: {stat.risk}%</li>
    </ul>
  </div>);
}


function state2props(state) {
  console.log("rerender", state);
  return {
    portfolio: state.portfolio,
    user: state.users,
    stats: state.portfolio_stats
  };
}


function render_portfolio_history(portfolio_id) {
  $.ajax(`http://localhost:4000/api/portfolio_history?id=${portfolio_id}`, {
  method: "get",
  dataType: "json",
  contentType: "application/json; charset=UTF-8",
  success: (resp) => {
    let dates = _.map(resp, function(x){return x["date"]});
    let data = _.map(resp, function(x){return x["value"]});
    linear_graph("portfolio-history-chart", "portfolio", dates, data)
  },
  });
}

function linear_graph(canvas_id, abbrev, x_array, y_array) {
  if(window.chart1){window.chart1.destroy()};
  window.chart1 = new Chart(document.getElementById(canvas_id), {
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

function render_pie_chart(stock_names, data_array) {
  if(window.chart2){window.chart2.destroy()};
  window.chart2 = new Chart(document.getElementById("doughnut-chart"), {
    type: 'doughnut',
    data: {
      labels: stock_names,
      datasets: [
        {
          label: "Population (millions)",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: data_array
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: 'portfolio composition'
      }
    }
  });
}

function render_portfolio_composition(portfolio_id) {
  $.ajax(`http://localhost:4000/api/portfolio_stats?id=${portfolio_id}`, {
  method: "get",
  dataType: "json",
  contentType: "application/json; charset=UTF-8",
  success: (resp) => {
    let stocks = _.map(resp["composition"], function(x){return x["abbreviation"]});
    let data = _.map(resp["composition"], function(x){return x["weight"] * 100});
    render_pie_chart(stocks, data)
  },
  });
}



// Export result of curried function call.
export default connect(
  state2props
)(PortfolioIndex);
