import { observable, action } from 'mobx';
import { getUsers, setInstructor, setAdmin} from '../api/users';

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

  @action
  toggleInstructor(id, value){
    setInstructor(id, value).then((response) => {
      let user = this.users.find((user) => user.id === response.data.data.id);
      user.instructor = response.data.data.attributes.instructor;
    });
  }

  @action
  toggleAdmin(id, value){
    setAdmin(id, value).then((response) => {
      let user = this.users.find((user) => user.id === response.data.data.id);
      user.admin = response.data.data.attributes.admin;
    });
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
