import React, { Component } from 'react';
import {Table} from 'reactstrap';
import {inject, observer} from 'mobx-react'

@inject('userStore')
@observer
export default class UsersTable extends Component {
  render() {
    return (
      <Table>
        <thead>
        <tr>
          <th>Name</th>
          <th>Admin</th>
          <th>Instructor</th>
        </tr>
        </thead>
        <tbody>
        { this.props.userStore.users.map( (user) => {
          return (<tr>
            <td>{user.name}</td>
            <td>{user.admin.toString()}</td>
            <td>{user.instructor.toString()}</td>
          </tr>)
        } )}
        </tbody>
      </Table>
    );
  }
}
