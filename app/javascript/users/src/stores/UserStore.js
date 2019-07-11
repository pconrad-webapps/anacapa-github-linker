import { observable } from 'mobx';

export default class UserStore {
  @observable users = [
    {
      name: 'Adam McAdmin',
      admin: true,
      instructor: false
    },
    {
      name: 'Jay Teacherface',
      admin: false,
      instructor: true
    },
    {
      name: 'Chris Gaucho',
      admin: false,
      instructor: false
    }
  ];
}
