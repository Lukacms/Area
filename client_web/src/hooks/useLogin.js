import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import * as Yup from 'yup';
import { getFirstInfos, login } from '../config/request';
import secureLocalStorage from 'react-secure-storage';

const useLogin = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const initialValues = {
    email: '',
    password: '',
  };

  const validate = Yup.object().shape({
    email: Yup.string().email('Invalid email').required('Required'),
    password: Yup.string().min(8, 'Too short').max(50, 'Too long').required('Required'),
  });

  const loginUser = async (values) => {
    setLoading(true);
    try {
      const data = await login(values);
      secureLocalStorage.setItem('token', data.data.access_token);
      const user = await getFirstInfos(data.data.access_token);
      secureLocalStorage.setItem('userId', user.data.id);
      navigate('/home');
    } catch (error) {
      setError(error.message);
    }
    setLoading(false);
  };

  return { loginUser, navigate, initialValues, validate, loading, error, setError };
};

export default useLogin;
