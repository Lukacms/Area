import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { serviceCallbackSpotify } from '../../config/request';
import { getByValue } from '../../config/commons';

/**
 * Fetch callback function from back for spotify login
 * @returns {{navigate: NavigateFunction, success: boolean, loading: boolean}}
 */
const useCallbackSpotify = () => {
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
        const res = await serviceCallbackSpotify(data);
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

export default useCallbackSpotify;
