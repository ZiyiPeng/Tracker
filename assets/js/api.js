import store from './store';


//adapted from https://www.w3schools.com/js/js_cookies.asp
function getCookie(cname) {
  var name = cname + "=";
  var decodedCookie = decodeURIComponent(document.cookie);
  var ca = decodedCookie.split(';');
  for(var i = 0; i <ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

class TheServer {

  send_get(path, callback) {
    $.ajax(path, {
      method: "get",
      headers: {"x-auth": getCookie("token")},
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: callback,
    });
  }

  send_post(path, data, callback) {
    $.ajax(path, {
      headers: {"x-auth": getCookie("token")},
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(data),
      success: callback,
    });
  }


  add_record(params) {
    this.send_post(
      "/api/records", {"record": params},
      (resp) => {
      console.log(resp);
        store.dispatch({
          type: 'RECORD_ADD',
          data: resp.data,
        });
        this.send_get(
          "/api/portfolio_stats/?id="+ window.portfolio_id,
          (resp) => {
            console.log("add_get_stat", resp);
            store.dispatch({
              type: 'PPORTFOLIO_STATS_GET',
              data: resp,
            });
            alert("Success");
          }
        );
      }
    );
  }

  prepare_stock(abbrev) {
    this.send_post(
      "/api/prepare_stock", {abbreviation: abbrev},
      (resp) => {
        store.dispatch({
          type: 'STOCK_PREPARE',
          data: resp,
        });
      }
    );
  }


  list_users() {
    this.send_get(
      "/api/users",
      (resp) => {
        store.dispatch({
          type: 'USER_LIST',
          data: resp.data,
        });
      }
    );
  }

  get_portfolio(id) {
    window.portfolio_id = id;
    this.send_get(
      "/api/portfolio/"+ id,
      (resp) => {
        store.dispatch({
          type: 'PPORTFOLIO_GET',
          data: resp.data,
        });
      }
    );
  }

  delete_record(id) {
    $.ajax('/api/records/' + id, {
      method: "delete",
      headers: {"x-auth": getCookie("token")},
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'RECORD_DELETE',
          data: id,
        });
        this.send_get(
          "/api/portfolio_stats?id="+ window.portfolio_id,
          (resp) => {
            store.dispatch({
              type: 'PPORTFOLIO_STATS_GET',
              data: resp,
            });
          }
        );
      }
    });
  }

  get_portfolio_stats(id) {
    this.send_get(
      "/api/portfolio_stats?id="+ id,
      (resp) => {
        store.dispatch({
          type: 'PPORTFOLIO_STATS_GET',
          data: resp,
        });
      }
    );
  }

  create_user() {
    let name = $("#create-user-name").val();
    let password = $("#create-user-password").val();
    let text =  {
        user: {
          name: name,
          password: password,
        },
      };
    this.send_post("/api/users", text, resp=>{
      store.dispatch({
        type: 'USER_CREATE',
        data: resp.data,
      });
      this.create_session(name, password)
    });
  }

  create_session(name, password) {
  this.send_post(
    "/api/auth", {"name": name, "password": password},
    (resp) => {
      let temp = "token="+resp.data.token;
      document.cookie=temp;
      store.dispatch({
        type: 'NEW_SESSION',
        data: resp.data,
      });
    }
  );
}

  delete_session() {
    store.dispatch({
      type: 'DELETE_SESSION',
    });
  }

  get_company(abbrev) {
    this.send_get(
      "/api/stock_company?abbreviation="+abbrev,
      (resp) => {
        store.dispatch({
          type: 'COMPANY_GET',
          data: resp, 
        });
      }
    );
  }


}


export default new TheServer();
