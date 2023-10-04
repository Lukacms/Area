import axios from 'axios';
import { API_URL } from './constants';
import secureLocalStorage from 'react-secure-storage';

// used to refresh token when getting 403 error
const refreshToken = () => {};

export const axiosInstance = axios.create({
  headers: {
    Authorization: `Bearer ${secureLocalStorage.getItem('token')}`,
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': true,
  },
});

// causing the pages to crash, idk why
// intercept 403 code to refresh token
axios.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response.status === 403) {
      refreshToken();
    }
  },
);

export const getUsers = () => axiosInstance.get('Users');

export const register = (userData) =>
  axios.post(API_URL + 'Users/register', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });

export const login = (userData) =>
  axios.post(API_URL + 'Users/login', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });

export const getServices = () => axiosInstance.get(API_URL + 'Services');

export const getUserServices = (id) => axiosInstance.get(API_URL + `UserServices/${id}`);

export const getMyProfile = () => axiosInstance.get(API_URL + 'Users/me');
