import axios from 'axios';
import { API_URL } from './constants';

// used to refresh token when getting 403 error
// const refreshToken = () => {};

export const axiosInstance = (token) =>
  axios.create({
    headers: {
      Authorization: `Bearer ${token}`,
    },
    baseURL: API_URL,
  });

// causing the pages to crash, idk why
// intercept 403 code to refresh token
/* axios.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response.status === 403) {
      refreshToken();
    }
  },
); */

export const getUsers = (token) => axiosInstance(token, 'Users').get();

export const login = (userData) =>
  axios.post(API_URL + 'Users/register', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });

export const getServices = (token) => axiosInstance(token).get(API_URL + 'Services');

export const getUserServices = (token, id) => axiosInstance(token).get(API_URL + `UserServices/${id}`);
