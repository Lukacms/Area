import { useState } from 'react';
import { useNavigate } from 'react-router';
import { getServices, getUserServices } from '../config/request';

const useSettingServices = () => {
  const [services, setServices] = useState([]);
  const navigate = useNavigate();

  const mouais = [
    {
      id: 0,
      name: 'discord',
      logo: process.env.PUBLIC_URL + 'icon.png',
      userConnected: false,
    },
    {
      id: 1,
      name: 'google',
      logo: process.env.PUBLIC_URL + 'icon.png',
      userConnected: true,
    },
  ];

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
      const existingServices = await getServices('');
      const userConnected = await getUserServices('', 0);
      const tmpServices = [];

      existingServices.data.forEach((item) => {
        tmpServices.push({
          id: item.id,
          name: item.name,
          logo: item.logo,
          userConnected: isUserConnected(userConnected, item.id),
          onClick: () => navigate('/settings/services/' + item.id),
        });
      });
      setServices(mouais);
    };
    fillServices();
  }, []);

  return { services, navigate };
};

export default useSettingServices;
