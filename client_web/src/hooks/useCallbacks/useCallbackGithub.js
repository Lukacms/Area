import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { serviceCallbackGithub } from '../../config/request';
import { getByValue } from '../../config/commons';

const useCallbackGithub = () => {
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
        const res = await serviceCallbackGithub(data);
        if (res.status.toString().startsWith('2')) {
          setSuccess(true);
        }
      } catch (error) {
        setSuccess(false);
      }
      setLoading(false);
    };
    fetchCallback();
  }, []);

  return { navigate, success, loading };
};

export default useCallbackGithub;
