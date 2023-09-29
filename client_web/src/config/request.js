import axios from 'axios';
import { API_URL } from './constants';

// used to refresh token when getting 403 error
// const refreshToken = () => {};

export const axiosInstance = (token, url) =>
  axios.create({
    headers: {
      Authorization: `Bearer ${token}`,
    },
    baseURL: API_URL,
    url: url,
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

export const login = (userData) => axios.post(API_URL + 'Users/register', userData);
