import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import _ from "lodash";

$(function() {
  function get_suggestsions(input) {
    console.log("input: "+ input)
    $.ajax(`http://localhost:4000/api/stock_search?input=${input}`, {
    method: "get",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    success: (resp) => {
      console.log(resp)
      let option = _.map(resp["best_matches"], function(e) {
        return e["1. symbol"] + " (" + e["2. name"] + ")"
      });
      console.log(option)
      $( "#autocomplete" ).autocomplete({
        source: option
      });
    },
    });
  }

  $("#autocomplete").on('input', function(){
    console.log("reached")
    let input = document.getElementById("autocomplete").value;
    get_suggestsions(input);
  });

  });
