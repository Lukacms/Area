import { useState } from 'react';
import { useNavigate } from 'react-router';
import { getServices, getUserServices } from '../config/request';

const useSettingServices = () => {
  const [services, setServices] = useState([]);
  const navigate = useNavigate();

  const isUserConnected = (user, id) => {
    user.forEach((item) => {
      if (item.serviceId === id) {
        return true;
      }
    });
    return false;
  };

  useState(() => {
    const fillServices = async () => {
      try {
        const existingServices = await getServices('');
        const userConnected = await getUserServices('', 0);
        const tmpServices = [];

        existingServices.data.forEach((item) => {
          tmpServices.push({
            id: item.id,
            name: item.name,
            logo: item.logo,
            userConnected: isUserConnected(userConnected, item.id),
            connectionLink: item.connectionLink,
            endpoint: item.endpoint,
          });
        });
        setServices(tmpServices);
      } catch (e) {
        navigate('/error', { state: { message: e.message } });
      }
    };
    fillServices();
  }, []);

  return { services, navigate };
};

export default useSettingServices;
