import { useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';

const useSpecificService = () => {
  const navigate = useNavigate();
  const { state } = useLocation();
  const item = state?.item;

  const connect = () => {
    window.open(item.connectionLink, '_self');
  };

  const changeAccount = () => {};

  const disconnect = () => {};

  useEffect(() => {
    if (!state || !item) {
      navigate('/error', { state: { message: "Coulnd't find service" } });
    }
  }, [state, item, navigate]);

  return { navigate, item, connect, changeAccount, disconnect };
};

export default useSpecificService;
