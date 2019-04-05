import React from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import api from '../api';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';


export default function RecordList(props) {
  var display;
    let task = _.map(props.records, (tt) => <Record key={tt.id} record={tt} />);
    display =
    <div className="col-12">
      <table className="table">
        <thead>
          <tr>
            <th>quantity</th>
            <th>purchase price</th>
            <th>stock</th>
            <th>Operation</th>
          </tr>
        </thead>
        <tbody>
          {task}
        </tbody>
      </table>
    </div>
  return <div className="row justify-content-md-center">
      {display}
  </div>;
}


function Record(props) {

  let record = props.record;
  return <tr>
    <td>{record.quantity}</td>
    <td>{record.purchased_price}</td>
    <td>{record.stock.abbreviation}</td>
    <td>
      <button className="button" className="btn btn-danger" onClick={() => { api.delete_record(record.id)}}> Delete</button>
    </td>
  </tr>;
}
