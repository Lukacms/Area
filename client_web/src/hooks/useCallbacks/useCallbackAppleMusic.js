import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { getByValue } from '../../config/commons';

const useCallbackAppleMusic = () => {
  const navigate = useNavigate();
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCallback = async () => {};
    fetchCallback();
  }, []);

  return { navigate, success, loading };
};

export default useCallbackAppleMusic;
