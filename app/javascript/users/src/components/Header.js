import React, { Component } from 'react';

export default class Header extends Component {
  render() {
    return (
      <div>
        <h1>Users</h1>

        <p>
          You can promote users to either admins or Instructors. If you promote a user to an Instructor, then that use will be able to create courses.
          NOTE: If you remove a user's instructor status, he/she will permanently lose access to all his/her courses.
        </p>
      </div>
    );
  }
}