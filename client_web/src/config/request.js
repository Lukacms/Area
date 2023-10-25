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

// login
export const login = (userData) =>
  axios.post(API_URL + 'Users/login', userData, {
    headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': true },
  });
// login with google
export const loginGoogle = (data) =>
  axios.post(API_URL + 'Users/googleLogin', data, {
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

export const changeUser = (data) => axiosInstance.put(API_URL + 'Users', data);

export const getServices = () => axiosInstance.get(API_URL + 'Services');

export const getUserServices = (id) => axiosInstance.get(API_URL + `UserServices/${id}`);

export const getMyProfile = () => axiosInstance.get(API_URL + 'Users/me');

export const getActions = () => axiosInstance.get(API_URL + 'Actions');

export const getActionsByServiceId = (id) => axiosInstance.get(API_URL + `Actions/${id}`);

export const getReactions = () => axiosInstance.get(API_URL + 'Reactions');

export const getReactionsByServiceId = (id) => axiosInstance.get(API_URL + `Reactions/${id}`);

export const disconnectUserService = (id) => axiosInstance.delete(API_URL + `UserServices/${id}`);

export const putArea = (area) => axiosInstance.put(API_URL + 'Areas', area);

export const postArea = (area) => axiosInstance.post(API_URL + 'Areas', area);

export const delArea = (areaId) => axiosInstance.delete(API_URL + `Areas/${areaId}`);

export const postUserAction = (userAction) =>
  axiosInstance.post(API_URL + 'UserActions', userAction);

export const postUserReaction = (userAction) =>
  axiosInstance.post(API_URL + 'UserReactions', userAction);

export const getUsersAreas = (id) => axiosInstance.get(API_URL + `Areas/${id}/full`);

// services callbacks
export const serviceCallbackDiscord = (datas) => axiosInstance.post(OAUTH_URL + 'Discord', datas);
export const serviceCallbackGoogle = (datas) => axiosInstance.post(OAUTH_URL + 'Google', datas);
export const serviceCallbackSpotify = (datas) => axiosInstance.post(OAUTH_URL + 'Spotify', datas);
export const serviceCallbackGithub = (datas) => axiosInstance.post(OAUTH_URL + 'Github', datas);

// admin
export const getAllUsers = () => axiosInstance.get(API_URL + 'Users');
export const addAction = (data) => axiosInstance.post(API_URL + 'Actions', data);
export const addReaction = (data) => axiosInstance.post(API_URL + 'Reactions', data);
export const delAction = (actionId) => axiosInstance.delete(API_URL + `Actions/${actionId}`);
export const delReaction = (reactionId) =>
  axiosInstance.delete(API_URL + `Reactions/${reactionId}`);
export const changeAdmin = (data) => axiosInstance.put(API_URL + `Users/partialModif`, data);
