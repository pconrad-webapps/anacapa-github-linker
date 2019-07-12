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

export function setInstructor(id, value){
    return axios.patch(`http://localhost:3000/api/users/${id}`,{
        data: {
            attributes:{
                instructor: value
            }
        }
    }, {
        headers: {
            'Content-Type': 'application/vnd.api+json',
        }
    });
}

export function setAdmin(id, value){
    return axios.patch(`http://localhost:3000/api/users/${id}`,{
        data: {
            attributes:{
                admin: value
            }
        }
    }, {
        headers: {
            'Content-Type': 'application/vnd.api+json',
        }
    });
}
