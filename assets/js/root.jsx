import React from 'react';
import ReactDOM from 'react-dom';
import { Link, BrowserRouter as Router, Route } from 'react-router-dom';
import _ from 'lodash';
import $ from 'jquery';
import { Provider } from 'react-redux';

import api from './api';

import Header from './header';
//import UserList from './component/user_list';
//import TaskList from './component/task_list';
//import CreateTaskForm from './component/create_task_form';
import PortfolioIndex from './component/portfolio_index';
import StockIndex from './component/stock_index';
import CreateUserForm from './component/create_user_form';

export default function root_init(node, store) {
  //let tasks = window.tasks;
  ReactDOM.render(
    <Provider store={store}>
      <Root/>
    </Provider>, node);
}

class Root extends React.Component {
  constructor(props) {
    super(props);
    api.list_users();
  }

  render() {
    return <div>
      <Router>
        <div>
          <Header />
          <div className="row">
            <div>
              <Route path="/create_user_form" exact={true} render={() =>
                <CreateUserForm />
              } />
              <Route path="/portfolio" exact={true} render={() =>
                <PortfolioIndex />
              } />
              <Route path="/stock" exact={true} render={() =>
                <StockIndex />
              } />
            </div>
          </div>
        </div>
      </Router>
    </div>;
  }
}
