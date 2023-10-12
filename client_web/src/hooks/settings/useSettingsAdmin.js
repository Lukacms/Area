import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import { getActions, getAllUsers, getReactions, getServices } from '../../config/request';
import * as Yup from 'yup';

const useSettingsAdmin = () => {
  const navigate = useNavigate();
  const [actions, setActions] = useState([]);
  const [reactions, setReactions] = useState([]);
  const [services, setServices] = useState([]);
  const [users, setUsers] = useState([]);
  const [label, setLabel] = useState('none');
  const initValues = {
    name: '',
    endpoint: '',
    service: {},
  };

  const getServiceName = (item, services) => {
    var name = 'no name found';

    services.forEach((service) => {
      if (service.id === item.serviceId) {
        name = service.name;
        return;
      }
    });
    return name;
  };

  const validate = Yup.object().shape({
    name: Yup.string().min(3, 'Not enough characters').max(35, 'Too long').required('Required'),
    endpoint: Yup.string().min(3, 'Not enough characters').max(35, 'Too long').required('Required'),
    service: Yup.object()
      .shape({ name: Yup.string().required('Required') })
      .required('Required'),
  });

  const submitAction = async (values) => {
    try {
      // send axios request
      setActions([
        ...actions,
        {
          name: values.name,
          endpoint: values.endpoint,
          service: values.service.name,
        },
      ]);
    } catch (e) {
      navigate('/error', { state: { message: e.message } });
    }
  };

  const submitReaction = async (values) => {
    try {
      // send axios request
      setReactions([
        ...reactions,
        {
          name: values.name,
          endpoint: values.endpoint,
          service: values.service.name,
        },
      ]);
    } catch (e) {
      navigate('/error', { state: { message: e.message } });
    }
  };

  useEffect(() => {
    const checkAbility = () => {
      const isAdmin = secureLocalStorage.getItem('isAdmin');
      if (!isAdmin) {
        navigate('/error', { state: { message: 'Forbidden.' } });
      }
    };

    const getData = async () => {
      try {
        const dActions = await getActions();
        const dReactions = await getReactions();
        const dUsers = await getAllUsers();
        const dServices = await getServices();

        setActions(
          dActions.data.map((item) => ({ ...item, service: getServiceName(item, dServices.data) })),
        );
        setReactions(
          dReactions.data.map((item) => ({
            ...item,
            service: getServiceName(item, dServices.data),
          })),
        );
        setServices(dServices.data);
        setUsers(dUsers.data);
      } catch (e) {
        navigate('/error', { state: { message: e.message } });
      }
    };

    checkAbility();
    getData();
  }, []);

  return {
    navigate,
    label,
    setLabel,
    actions,
    reactions,
    setActions,
    setReactions,
    services,
    users,
    initValues,
    validate,
    submitAction,
    submitReaction,
  };
};

export default useSettingsAdmin;
