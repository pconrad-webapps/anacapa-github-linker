import { observable, action } from 'mobx';
import { getUsers } from '../api/users';
export default class UserStore {
  @observable users = [];
  @observable currentPage = 1;
  const perPage = 10;

  @action
  setUsers(users) {
    this.users = users;
  }

  @action
  setCurrentPage(page) {
    this.currentPage = page;
    this.load();
  }

  load() {
    getUsers(this.currentPage, this.perPage).then(response => {
      this.setUsers(response.data);
    });
  }
}
