import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { getServices, getUserServices } from '../../config/request';
import secureLocalStorage from 'react-secure-storage';

const useSettingServices = () => {
  const [services, setServices] = useState([]);
  const navigate = useNavigate();
  const [loaded, setLoaded] = useState(false);
  const [isAdmin, setIsAdmin] = useState(false);

  const isUserConnected = (user, id) => {
    var userConnect = false;

    if (!user) {
      return false;
    }
    user.forEach((item) => {
      if (item.serviceId === id) {
        userConnect = true;
      }
    });
    return userConnect;
  };

  const findUserServiceId = (user, id) => {
    var serviceId = -1;

    if (!user) return -1;
    user?.forEach((item) => {
      if (item.serviceId === id) {
        serviceId = item.id;
      }
    });
    return serviceId;
  };

  useEffect(() => {
    const fetchData = async () => {
      setIsAdmin(secureLocalStorage.getItem('isAdmin'));
      try {
        const userId = secureLocalStorage.getItem('userId');
        const existingServices = await getServices();
        const userConnected = await getUserServices(userId);
        const tmpServices = [];

        existingServices.data.forEach((item) => {
          tmpServices.push({
            id: item.id,
            name: item.name,
            logo: item.logo,
            userConnected: isUserConnected(userConnected.data, item.id),
            userServiceId: findUserServiceId(userConnected.data, item.id),
            connectionLink: item.connectionLink,
            endpoint: item.endpoint,
            oauth: item.isConnectionNeeded
          });
        });
        setServices(tmpServices);
        setLoaded(true);
      } catch (e) {
        navigate('/error', { state: { message: e.message } });
      }
    };
    fetchData();
  }, [navigate]);

  return { services, navigate, loaded, isAdmin };
};

export default useSettingServices;
