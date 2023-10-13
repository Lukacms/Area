import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { serviceCallbackDiscord } from '../../config/request';
import { getByValue } from '../../config/commons';

const useCallbackDeezer = () => {
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

export default useCallbackDeezer;
