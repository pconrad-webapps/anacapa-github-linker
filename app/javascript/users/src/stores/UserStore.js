import { observable, action } from 'mobx';
import { getUsers } from '../api/users';
export default class UserStore {
  @observable users = [];

  @action
  setUsers(users) {
    this.users = users;
  }

  load() {
    getUsers().then(response => {
      this.setUsers(response.data);
    });
  }
}
