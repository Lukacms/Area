import { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import { disconnectUserService } from '../../config/request';

const useSpecificService = () => {
  const navigate = useNavigate();
  const { state } = useLocation();
  const item = state?.item;
  const [isAdmin, setIsAdmin] = useState(false);

  const connect = () => {
    window.open(item.connectionLink, '_self');
  };

  const changeAccount = async () => {
    try {
      await disconnectUserService(item.userServiceId);
      window.open(item.connectionLink, '_self');
    } catch (e) {
      navigate('/error', { state: { message: e.message } });
    }
  };

  const disconnect = async () => {
    try {
      await disconnectUserService(item.userServiceId);
      navigate('/settings/services');
    } catch (e) {
      navigate('/error', { state: { message: e.message } });
    }
  };

  useEffect(() => {
    if (!state || !item) {
      navigate('/error', { state: { message: "Coulnd't find service" } });
    }
    setIsAdmin(secureLocalStorage.getItem('isAdmin'));
  }, [state, item, navigate]);

  return { navigate, item, connect, changeAccount, disconnect, isAdmin };
};

export default useSpecificService;
