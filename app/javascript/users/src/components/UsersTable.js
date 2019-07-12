import React, { Component } from 'react';
import {Table, Pagination, PaginationItem, PaginationLink } from 'reactstrap';
import {inject, observer} from 'mobx-react'
import UsersTablePagination from './UsersTablePagination'

@inject('userStore')
@observer
export default class UsersTable extends Component {

  componentDidMount() {
    this.props.userStore.load();
  }
  render() {
    return (
      <div>
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
      <UsersTablePagination />

      </div>
  );
  }
}
