import axios from 'axios';
import { getServices, getActionsByServiceId, getReactionsByServiceId } from '../config/request';
import { useEffect, useState } from 'react';

/**
 * Give about object that is asked in subject. Should have been in backend, but is also here with custom css
 * @returns {{about: {}, loaded: boolean,
 * services: Array<{name: string, actions: Array<{name: string, description: string}>, reactions: Array<{name: string, description: string}>}}
 */
const useAbout = () => {
  const [about, setAbout] = useState({
    client: {
      host: '',
    },
    server: {
      current_time: '',
      services: [],
    },
  });
  const [services, setServices] = useState([]);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const fetchIp = async () => {
      try {
        const res = await axios.get('https://geolocation-db.com/json/', {
          headers: {
            Accept:
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
          },
        });

        setAbout(
          (old) =>
            [
              {
                ...old,
                client: { host: res.data.IPv4 },
                server: { ...old.server, current_time: new Date().getTime() },
              },
            ][0],
        );
      } catch (e) {
        console.log(e);
      }
    };

    const fetchServices = async () => {
      try {
        const servicesData = await getServices();

        servicesData.data.forEach(async (item) => {
          const actions = await getActionsByServiceId(item.id);
          const reactions = await getReactionsByServiceId(item.id);
          const serviceItem = {
            name: item.name,
            actions: actions.data.map((action) => ({
              name: action.name,
              description: action.description ? action.description: ''
            })),
            reactions: reactions.data.map((reaction) => ({
              name: reaction.name,
              description: reaction.description ? reaction.description: ''
            })),
          };
          setServices((old) => [...old, serviceItem]);
        });
        setLoaded(true);
      } catch (e) {
        console.log(e);
      }
    };

    fetchIp();
    fetchServices();
  }, []);

  return { about, loaded, services };
};

export default useAbout;
