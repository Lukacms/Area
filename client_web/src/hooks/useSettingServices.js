import { useState } from 'react';
import { getServices, getUserServices } from '../config/request';

const useSettingServices = () => {
  const [services, setServices] = useState([]);

  const isUserConnected = (user, id) => {
    user.forEach((item) => {
      if (item.serviceId === id) {
        return true;
      }
    });
    return false;
  }

  useState(() => {
    const fillServices = async () => {
      const existingServices = await getServices('');
      const userConnected = await getUserServices('', 0);
      const tmpServices = [];

      existingServices.data.forEach((item) => {
        tmpServices.push({
          name: item.name,
          logo: item.logo,
          userConnected: isUserConnected(userConnected, item.id),
        })
      });
      setServices(tmpServices);
    };
    fillServices();
  }, []);

  return { services };
};

export default useSettingServices;
