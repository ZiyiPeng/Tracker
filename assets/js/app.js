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
      linear_graph(abbrev, dates, data)
    },
    });
  }


  function linear_graph(abbrev, x_array, y_array) {
    new Chart(document.getElementById("history-chart"), {
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
          text: 'stock price'
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

  $("#graph").html(render_stock_history("AAPL", "1m"))

});
