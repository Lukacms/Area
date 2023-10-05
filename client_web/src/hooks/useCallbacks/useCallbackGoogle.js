import { useState } from 'react';
import { useNavigate/* , useSearchParams */ } from 'react-router-dom';

const useCallbackGoogle = () => {
  const navigate = useNavigate();
  // const [searchParams] = useSearchParams();
  const [loading/* , setLoading */] = useState(true);
  const [success/* , setSuccess */] = useState(false);

  return { navigate, success, loading };
};

export default useCallbackGoogle;
