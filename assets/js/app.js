import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import _ from "lodash";
import Chart from 'chart.js'

$(function() {
  //linear graph
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

  function render_pie_chart(stock_names, data_array) {
    new Chart(document.getElementById("doughnut-chart"), {
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



  //search box
  function get_suggestsions(input) {
    $.ajax(`http://localhost:4000/api/stock_search?input=${input}`, {
    method: "get",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    success: (resp) => {
      let option = _.map(resp["best_matches"], function(e) {
        return e["1. symbol"] + " (" + e["2. name"] + ")"
      });
      $( "#autocomplete" ).autocomplete({
        source: option
      });
    },
    });
  }

  $("#autocomplete").on('input', function(){
    let input = document.getElementById("autocomplete").value;
    get_suggestsions(input);
  });

  render_stock_history("AAPL", "1m");
  render_portfolio_history(1);
  render_portfolio_composition(1);
});
