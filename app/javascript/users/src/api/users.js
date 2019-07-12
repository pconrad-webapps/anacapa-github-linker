import axios from 'axios';
import qs from 'qs';

axios.interceptors.request.use(config => {
    config.paramsSerializer = params => {
        return qs.stringify(params, {
            arrayFormat: 'brackets',
            encode: false
        });
    };
    return config;
});

export function getUsers(page, pageSize) {
    return axios.get('http://localhost:3000/api/users',{
        params: {
            page:{
                number: page,
                size: pageSize
            }
        }
    });
}
