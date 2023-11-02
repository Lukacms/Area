import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { serviceCallbackMicrosoft } from '../../config/request';
import { getByValue } from '../../config/commons';

/**
 * Fetch callback function from back for microsoft login
 * @returns {{navigate: NavigateFunction, success: boolean, loading: boolean}}
 */
const useCallbackMicrosoft = () => {
  const navigate = useNavigate();
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCallback = async () => {
      const data = {
        code: getByValue(searchParams, 'code'),
      };

      try {
        const res = await serviceCallbackMicrosoft(data);
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

export default useCallbackMicrosoft;
