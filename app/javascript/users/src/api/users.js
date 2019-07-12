import axios from 'axios';

export function getUsers(page, perPage) {
    return axios.get('http://localhost:3000/api/users',{
        params: {
            page: page,
            per_page: perPage
        }
    });
}
