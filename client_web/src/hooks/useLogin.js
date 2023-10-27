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

  const googleSignIn = () => {
    const link = `https://accounts.google.com/o/oauth2/auth?scope=${process.env.REACT_APP_GOOGLE_SCOPE}&response_type=code&redirect_uri=${process.env.REACT_APP_REDIRECT_URI_LOGIN}&client_id=${process.env.REACT_APP_CLIENT_ID}&access_type=offline`;

    window.open(link, '_self')
  };

  const loginUser = async (values) => {
    setLoading(true);
    try {
      const res = await login(values);
      if (!res?.status?.toString().startsWith('2')) {
        setError('Wrong email or password');
        setLoading(false);
      }
      secureLocalStorage.setItem('token', res.data.access_token);
      const user = await getFirstInfos(res.data.access_token);
      secureLocalStorage.setItem('userId', user.data.id);
      secureLocalStorage.setItem('isAdmin', user.data.admin);
      navigate('/home');
    } catch (error) {
      setError(error.message);
    }
    setLoading(false);
  };

  return { loginUser, navigate, initialValues, validate, loading, error, setError, googleSignIn };
};

export default useLogin;

// https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fgmail.modify+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:8081%2Fsettings%2Fservices%2Fgoogle&client_id=315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com&access_type=offline
