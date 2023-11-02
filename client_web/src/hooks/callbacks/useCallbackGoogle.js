import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { serviceCallbackGoogle } from '../../config/request';
import { getByValue } from '../../config/commons';

/**
 * Fetch callback function from back for google login
 * @returns {{navigate: NavigateFunction, success: boolean, loading: boolean}}
 */
const useCallbackGoogle = () => {
  const navigate = useNavigate();
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCallback = async () => {
      const data = {
        code: getByValue(searchParams, 'code'),
        scope: getByValue(searchParams, 'scope'),
      };

      try {
        const res = await serviceCallbackGoogle(data);
        if (res.status.toString().startsWith('2')) {
          setSuccess(true);
        }
      } catch (error) {
        setSuccess(false);
      }
      setLoading(false);
    };
    fetchCallback();
  }, [navigate, searchParams]);

  return { navigate, success, loading };
};

export default useCallbackGoogle;
