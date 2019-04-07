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
  return (<div className="container" style={{marginBottom:'20px'}}>
  <div className='row'>
          <div className="chart-container card" style={{position:'relative', height:'30%', width:'70%', float:'left'}}>
            <canvas id="portfolio-history-chart" width="800" height="450" style={{width:'10%'}}></canvas>
          </div>
          <div className="chart-container card" style={{position:'relative', height:'30%', width:'30%', float:'right'}}>
            <canvas className="card-body" id="doughnut-chart" width="100px" height="100px"></canvas>
            <RenderStat className="card-body" stats={props.stats}/>
          </div>

          </div>
          <div className="card row">
          <div className="card-body">
            <RecordList records={props.portfolio.records}/>
          </div>
        </div>
        </div>
  )
}

function RenderStat(props) {
  let stat = props.stats;
  return (


  <div>
    <ul id='stats'>
      <h3>Statistics:</h3>
      <li>  Beta: {stat.beta}</li>
      <li>  Return: {Math.round(stat.rate_of_return * 100)/100}%</li>
      <li>  Risk: {stat.risk}%</li>
    </ul>
  </div>);
}


function state2props(state) {
  console.log("rerender", state);
  return {
    portfolio: state.portfolio,
    user: state.users,
    stats: state.portfolio_stats,
    session: state.session
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
        text: 'Portfolio Value'
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
        text: 'Portfolio Composition'
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
