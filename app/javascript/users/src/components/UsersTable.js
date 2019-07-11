import React, { Component } from 'react';
import {Table} from 'reactstrap';
import {inject, observer} from 'mobx-react'

@inject('userStore')
@observer
export default class UsersTable extends Component {

  componentDidMount() {
    this.props.userStore.load();
  }
  render() {
    return (
      <Table>
        <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>UID</th>
        </tr>
        </thead>
        <tbody>
        { this.props.userStore.users.map( (user) => {
          return (<tr>
            <td>{user.name}</td>
            <td>{user.email}</td>
            <td>{user.uid}</td>
          </tr>)
        } )}
        </tbody>
      </Table>
    );
  }
}
