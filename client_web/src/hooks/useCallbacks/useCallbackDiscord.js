import { useEffect, useState } from 'react';
import { useLocation, useSearchParams } from 'react-router-dom';
import { serviceCallbackDiscord } from '../../config/request';

const useCallbackDiscord = () => {
  const navigate = useLocation();
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCallback = async () => {
      const data = {
        searchParams,
      };

      try {
        const res = await serviceCallbackDiscord(data);
        if (res.status.toString().startsWith('2')) {
          setSuccess(true);
        }
      } catch (error) {
        setSuccess(false);
      }
      setLoading(false);
    };
    fetchCallback();
  }, [searchParams]);

  return { navigate, success, loading };
};

export default useCallbackDiscord;
