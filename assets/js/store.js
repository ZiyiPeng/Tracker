import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';


/*
  Application state layout
  {
    // Session
    session: null, // { token, user_id }
    // DB Caches
    users: [], // List of User
    tasks: []
    // Forms
    login_form: { email: "", password, "" },
    register_form
    add_task_form: new Map()
    edit_task_form
  }
*/

// For each component of the state:
//  * Function with the same name
//  * Default is the default value of that component

function portfolio(state=[], action) {
  switch (action.type) {
  case 'PPORTFOLIO_GET':
    return action.data;
  case 'RECORD_DELETE':
    console.log("record delete");
    let record_id = action.data;
    let new_state = Object.assign({}, state, {records: _.filter(state.records, (r)=>r.id!= record_id)});
    console.log("new state");
    console.log(new_state);
    return new_state;
  default:
    return state;
  }
}

function portfolio_stats(state=[], action) {
  switch (action.type) {
  case 'PPORTFOLIO_STATS_GET':
    return action.data;
  default:
    return state;
  }
}

function stock(state=[], action) {
  switch (action.type) {
  case 'PPORTFOLIO_GET':
    console.log(action.data);
    return action.data;
  default:
    return state;
}
}

function users(state=[], action) {
  switch (action.type) {
  case 'USER_LIST':
    return action.data;
  case 'USER_CREATE':
    return [...state, action.data];
  default:
    return state;
  }
}


function session(state = null, action) {
  switch (action.type) {
  case 'NEW_SESSION':
    return action.data;
  case 'DELETE_SESSION':
    return null;
  default:
    return state;
  }
}

let login_form0 = {name: "", password: ""};
function login_form(state = login_form0, action) {
  return state;
}


function root_reducer(state0, action) {
  //console.log("reducer", state0, action);

  let reducer = combineReducers({portfolio: portfolio, users: users,session: session,
    current_stock: stock,
    portfolio_stats: portfolio_stats});
  let state1 = reducer(state0, action);

  console.log("reducer1", state1);

  return deepFreeze(state1);
}


let store = createStore(root_reducer);
export default store;
