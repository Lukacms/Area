import { useRef } from "react";
import { useNavigate } from "react-router-dom";
import secureLocalStorage from "react-secure-storage";
import * as Yup from 'yup';

const useSettingsUser = () => {
  const navigate = useNavigate();
  const passwordValues = {
    password: '',
    passwordCheck: ''
  };
  const buttonEl = useRef(null);

  const validation = Yup.object().shape({
    password: Yup.string().min(8, 'Must be 8 characters minimum').required('Required'),
    passwordCheck: Yup.string()
      .equals([Yup.ref('password'), null], 'This field must be identical to the one above')
      .required('Required')
  });

  const changePassword = async (values) => {};

  const logout = () => {
    secureLocalStorage.removeItem("token");
    secureLocalStorage.removeItem("userId");
    navigate('/');
  };

  return { navigate, passwordValues, validation, changePassword, logout, buttonEl };
};

export default useSettingsUser;
