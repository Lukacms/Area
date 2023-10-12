import axios from 'axios';
import { API_URL, OAUTH_URL } from './constants';
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

export const register = (userData) =>
  axios.post(API_URL + 'Users/register', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });

export const login = (userData) =>
  axios.post(API_URL + 'Users/login', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });

export const getFirstInfos = (token) =>
  axios.get(API_URL + 'Users/me', {
    headers: {
      Authorization: `Bearer ${token}`,
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': true,
    },
  });

export const getServices = () => axiosInstance.get(API_URL + 'Services');

export const getUserServices = (id) => axiosInstance.get(API_URL + `UserServices/${id}`);

export const getMyProfile = () => axiosInstance.get(API_URL + 'Users/me');

export const getActions = () => axiosInstance.get(API_URL + 'Actions');

export const getActionsByServiceId = (id) => axiosInstance.get(API_URL + `Actions/${id}`);

export const getReactions = () => axiosInstance.get(API_URL + 'Reactions');

export const getReactionsByServiceId = (id) => axiosInstance.get(API_URL + `Reactions/${id}`);

export const disconnectUserService = (id) => axiosInstance.delete(API_URL + `UserServices/${id}`);

export const getUsersAreas = (id) => axiosInstance.get(API_URL + `Areas/${id}`);

// services callbacks
export const serviceCallbackDiscord = (datas) => axiosInstance.post(OAUTH_URL + 'Discord', datas);
export const serviceCallbackGoogle = (datas) => axiosInstance.post(OAUTH_URL + 'Google', datas);
export const serviceCallbackSpotify = (datas) => axiosInstance.post(OAUTH_URL + 'Spotify', datas);
export const serviceCallbackGithub = (datas) => axiosInstance.post(OAUTH_URL + 'Github', datas);

// admin
export const getAllUsers = () => axiosInstance.get(API_URL + 'Users');
