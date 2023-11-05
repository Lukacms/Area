import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import * as Yup from 'yup';
import { changeUser, getFirstInfos } from '../../config/request';

/**
 * Provide SettingsUser pages everything needed that is not display
 * @returns {{navigate: NavigateFunction, passwordValues: {}, validation: Yup.ObjectSchema,
 * changePassword: Function, logout: Function, buttonEl: MutableRefObject<null>,
 * isAdmin: boolean, toast: MutableRefObject<null>}}
 */
const useSettingsUser = () => {
  const navigate = useNavigate();
  const [isAdmin, setIsAdmin] = useState(false);
  const passwordValues = {
    password: '',
    passwordCheck: '',
  };
  const buttonEl = useRef(null);
  const toast = useRef(null);

  const validation = Yup.object().shape({
    password: Yup.string().min(8, 'Must be 8 characters minimum').required('Required'),
    passwordCheck: Yup.string()
      .equals([Yup.ref('password'), null], 'This field must be identical to the one above')
      .required('Required'),
  });

  const changePassword = async (values) => {
    try {
      const user =  await getFirstInfos(secureLocalStorage.getItem('token'));
      const res = await changeUser({...user.data, password: values.password});
      console.log(res?.data);
      toast.current.show({ severity: 'success', summary: 'Success' });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While changing password',
        detail: e.message,
      });
    }
  };

  const logout = () => {
    secureLocalStorage.removeItem('token');
    secureLocalStorage.removeItem('userId');
    secureLocalStorage.removeItem('isAdmin');
    navigate('/');
  };

  useEffect(() => {
    setIsAdmin(secureLocalStorage.getItem('isAdmin'));
  }, []);

  return { navigate, passwordValues, validation, changePassword, logout, buttonEl, isAdmin, toast };
};
export default useSettingsUser;
