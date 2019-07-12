import { observable, action } from 'mobx';
import { getUsers } from '../api/users';
export default class UserStore {
  @observable users = [];
  @observable currentPage = 1;
  @observable totalPages = 0;
  @observable pageSize = 10;

  @action
  setUsers(users) {
    this.users = users;
  }

  @action
  setTotalPages(totalPages) {
    this.totalPages = totalPages;
  }


  @action
  setCurrentPage(page) {
    this.currentPage = page;
    this.load();
  }

  load() {
    getUsers(this.currentPage, this.pageSize).then(response => {
      const users = response.data.data.map((user) => {
        return {
          ...user.attributes,
          id: user.id
        };
      });
      this.setUsers(users);
      this.setTotalPages(response.data.meta.total_pages);
    });
  }
}
