import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import {
  getActionsByServiceId,
  getServices,
  getUserServices,
  getUsersAreas,
  getReactionsByServiceId,
} from '../config/request';

const useFetchHome = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [actionReac, setActionReac] = useState('Actions');
  const [panelActions, setPanelActions] = useState([]);
  const [panelReactions, setPanelReactions] = useState([]);
  const [tabAreas, setTabAreas] = useState([]);

  useEffect(() => {
    const loadDatas = async () => {
      const userId = secureLocalStorage.getItem('userId');

      setLoading(true);
      try {
        const services = await getServices();
        const userServices = await getUserServices(userId);
        const usersAreas = await getUsersAreas(userId);

        services.data.forEach((service) => {
          userServices.data.forEach(async (item) => {
            if (service.id === item.serviceId) {
              const actions = await getActionsByServiceId(item.serviceId);
              const reactions = await getReactionsByServiceId(item.serviceId);

              setPanelActions((old) => [
                ...old,
                {
                  label: service.name,
                  icon: 'pi pi-folder',
                  id: item.id,
                  items: actions.data?.map((action) => {
                    return { label: action.name, logo: '', command: () => {} };
                  }),
                },
              ]);
              setPanelReactions((old) => [
                ...old,
                {
                  label: service.name,
                  icon: 'pi pi-folder',
                  id: item.id,
                  items: reactions.data?.map((action) => {
                    return { label: action.name, logo: '', command: () => {} };
                  }),
                },
              ]);
            }
          });

          setTabAreas(usersAreas.data);
        });
      } catch (e) {
        navigate('/error', { state: { message: e.message } });
      }
      setLoading(false);
    };
    loadDatas();
  }, []);

  return { navigate, actionReac, setActionReac, panelActions, panelReactions, loading, tabAreas, setTabAreas };
};

export default useFetchHome;
