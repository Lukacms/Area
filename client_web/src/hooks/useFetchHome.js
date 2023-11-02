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
  const [status, setStatus] = useState('Default'); // Default | GetName | GetAction | ConfigureAction | GetReactions | ConfigureReaction | Validate
  const actionReacOpts = [
    { label: 'Actions', disabled: status === 'GetReactions' || status === 'ConfigureReaction' },
    { label: 'Reactions', disabled: status === 'GetAction' || status === 'ConfigureAction' },
  ];

  useEffect(() => {
    const loadDatas = async () => {
      const userId = secureLocalStorage.getItem('userId');

      setLoading(true);
      try {
        const services = await getServices();
        const userServices = await getUserServices(userId);
        const usersAreas = await getUsersAreas(userId);

        services.data.forEach(async (service) => {
          if (!service.isConnectionNeeded) {
            const actions = await getActionsByServiceId(service.id);
            const reactions = await getReactionsByServiceId(service.id);

            setPanelActions((old) => [
              ...old,
              {
                label: service.name,
                icon: 'pi pi-folder',
                id: service.id,
                items: actions.data?.map((action) => {
                  return {
                    label: action.name,
                    id: action.id,
                    timer: 1,
                    logo: '',
                    configuration: action.defaultConfiguration
                      ? JSON.parse(action.defaultConfiguration)
                      : '',
                  };
                }),
              },
            ]);

            setPanelReactions((old) => [
              ...old,
              {
                label: service.name,
                icon: 'pi pi-folder',
                id: service.id,
                items: reactions.data?.map((reaction) => {
                  return {
                    label: reaction.name,
                    id: reaction.id,
                    logo: '',
                    configuration: reaction.defaultConfiguration
                      ? JSON.parse(reaction.defaultConfiguration)
                      : '',
                  };
                }),
              },
            ]);
          }
          userServices.data.forEach(async (item) => {
            if (service.id === item.serviceId) {
              const actions = await getActionsByServiceId(item.serviceId);
              const reactions = await getReactionsByServiceId(item.serviceId);

              setPanelActions((old) => [
                ...old,
                {
                  label: service.name,
                  icon: 'pi pi-folder',
                  id: service.id,
                  items: actions.data?.map((action) => {
                    return {
                      label: action.name,
                      desc: action.description,
                      id: action.id,
                      timer: 1,
                      logo: '',
                      configuration: action.defaultConfiguration
                        ? JSON.parse(action.defaultConfiguration)
                        : '',
                    };
                  }),
                },
              ]);

              setPanelReactions((old) => [
                ...old,
                {
                  label: service.name,
                  icon: 'pi pi-folder',
                  id: service.id,
                  items: reactions.data?.map((reaction) => {
                    return {
                      label: reaction.name,
                      desc: reaction.description,
                      id: reaction.id,
                      logo: '',
                      configuration: reaction.defaultConfiguration
                        ? JSON.parse(reaction.defaultConfiguration)
                        : '',
                    };
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
  }, [navigate]);

  return {
    navigate,
    actionReac,
    setActionReac,
    panelActions,
    panelReactions,
    loading,
    tabAreas,
    setTabAreas,
    status,
    setStatus,
    actionReacOpts,
  };
};

export default useFetchHome;
