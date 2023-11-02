import { useEffect, useRef } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import { getFirstInfos, loginGoogle } from '../../../config/request';
import { getByValue } from '../../../config/commons';

/**
 * Elements and fetch needed by CallbackLogin page. Try to connect to google as soon as page is launched
 * @returns {{ref: ref}} ref
 */
const useCallbackLogin = () => {
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const ref = useRef(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (ref.current) {
      ref.current.clear();
      ref.current.show({
        sticky: true,
        severity: 'info',
        summary: 'Loading',
        detail: 'Please wait, you will be redirected in an instant...',
        closable: false,
      });
    }

    const connectGoogle = async () => {
      const data = {
        code: getByValue(searchParams, 'code'),
        scope: getByValue(searchParams, 'scope'),
        callbackUri: 'http://localhost:8081/googleOauth',
      };

      try {
        const res = await loginGoogle(data);
        secureLocalStorage.setItem('token', res.data.access_token);
        const user = await getFirstInfos(res.data.access_token);
        secureLocalStorage.setItem('userId', user.data.id);
        secureLocalStorage.setItem('isAdmin', user.data.admin);
        navigate('/home');
      } catch (error) {
        navigate('/error', { state: { message: 'Could not connect with Google' } });
      }
    };

    connectGoogle();
  }, [navigate, searchParams]);

  return { ref };
};

export default useCallbackLogin;
