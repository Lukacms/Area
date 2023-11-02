import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import secureLocalStorage from 'react-secure-storage';
import {
  addAction,
  addReaction,
  changeAdmin,
  delAction,
  delReaction,
  getActions,
  getAllUsers,
  getReactions,
  getServices,
  modifyAction,
  modifyReaction,
} from '../../config/request';
import * as Yup from 'yup';
import { listToJsonObject } from '../../config/commons';

/**
 * Provide SettingsAdmin page everything needed
 * @returns {{
 * navigate: NavigateFunction, label: string, setLabel: Function,
 * actions: Array<{}>, reactions: Array<{}>, deleteAction: Function,
 * deleteReaction: Function, services: Array<{}>, users: Array<{}>, initValues: {},
 * validate: Function, submitAction: Function, submitReaction: Function, deleteAdmin: Function,
 * addAdmin: Function, toast: MutableRefObject<null>, changeAction: Function, changeReaction: Function
 * }}
 */
const useSettingsAdmin = () => {
  const navigate = useNavigate();
  const [actions, setActions] = useState([]);
  const [reactions, setReactions] = useState([]);
  const [services, setServices] = useState([]);
  const [users, setUsers] = useState([]);
  const [label, setLabel] = useState('Users');
  const toast = useRef(null);
  const initValues = {
    name: '',
    endpoint: '',
    service: {},
    defaultConfig: [],
    description: '',
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
    endpoint: Yup.string().min(1, 'Not enough characters').max(35, 'Too long').required('Required'),
    service: Yup.object().required('Required'),
    defaultConfig: Yup.array().nullable(),
  });

  const submitAction = async (values) => {
    try {
      const res = await addAction({
        endpoint: values.endpoint,
        name: values.name,
        serviceId: values.service.id,
        defaultConfiguration: listToJsonObject(values.defaultConfig),
        description: values.description,
      });
      setActions([
        ...actions,
        {
          id: res.data.id,
          name: values.name,
          endpoint: values.endpoint,
          service: values.service.name,
          defaultConfiguration: listToJsonObject(values.defaultConfig),
          description: values.description,
        },
      ]);
      toast.current.show({ severity: 'success', summary: 'Successfully added action' });
    } catch (e) {
      toast.current.show({ severity: 'error', summary: 'While adding action', detail: e.message });
    }
  };

  const submitReaction = async (values) => {
    try {
      const res = await addReaction({
        endpoint: values.endpoint,
        name: values.name,
        serviceId: values.service.id,
        defaultConfiguration: listToJsonObject(values.defaultConfig),
        description: values.description,
      });
      setReactions([
        ...reactions,
        {
          id: res.data.id,
          name: values.name,
          endpoint: values.endpoint,
          service: values.service.name,
          defaultConfiguration: listToJsonObject(values.defaultConfig),
          description: values.description,
        },
      ]);
      toast.current.show({ severity: 'success', summary: 'Successfully added reaction' });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While adding reaction',
        detail: e.message,
      });
    }
  };

  const changeAction = async (values) => {
    try {
      await modifyAction({
        id: values.id,
        endpoint: values.endpoint,
        name: values.name,
        serviceId: values.service.id,
        defaultConfiguration: listToJsonObject(values.defaultConfig),
        description: values.description,
      });
      setActions(
        actions.map((item) =>
          item.id === values.id
            ? {
                id: values.id,
                endpoint: values.endpoint,
                name: values.name,
                serviceId: values.service.id,
                defaultConfiguration: listToJsonObject(values.defaultConfig),
                description: values.description,
              }
            : item,
        ),
      );
      toast.current.show({ severity: 'success', summary: 'Successfully modified action' });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While modifying action',
        detail: e.message,
      });
    }
  };

  const changeReaction = async (values) => {
    try {
      await modifyReaction({
        id: values.id,
        endpoint: values.endpoint,
        name: values.name,
        serviceId: values.service.id,
        defaultConfiguration: listToJsonObject(values.defaultConfig),
        description: values.description,
      });
      setReactions(
        reactions.map((item) =>
          item.id === values.id
            ? {
                id: values.id,
                endpoint: values.endpoint,
                name: values.name,
                serviceId: values.service.id,
                defaultConfiguration: listToJsonObject(values.defaultConfig),
                description: values.description,
              }
            : item,
        ),
      );
      toast.current.show({ severity: 'success', summary: 'Successfully modified reaction' });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While modifying action',
        detail: e.message,
      });
    }
  };

  const deleteAdmin = async (user) => {
    if (user.id === secureLocalStorage.getItem('userId')) {
      toast.current.show({
        severity: 'error',
        summary: 'Not allowed',
        detail: 'You cannot revoke your own admin rights.',
      });
      return;
    }
    try {
      await changeAdmin({ ...user, admin: false });
      setUsers(users.map((item) => (item.id === user.id ? { ...item, admin: false } : item)));
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'Error',
        detail: e.message,
      });
    }
  };

  const addAdmin = async (user) => {
    // axios request
    try {
      await changeAdmin({ ...user, admin: true });
      setUsers(users.map((item) => (item.id === user.id ? { ...item, admin: true } : item)));
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'Error',
        detail: e.message,
      });
    }
  };

  const deleteAction = async (action) => {
    try {
      await delAction(action.id);
      setActions(actions.filter((item) => item !== action));
      toast.current.show({
        severity: 'success',
        summary: 'While deleting action',
        detail: 'Successfully deleted action',
      });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While deleting action',
        detail: e.message,
      });
    }
  };

  const deleteReaction = async (reaction) => {
    try {
      await delReaction(reaction.id);
      setReactions(reactions.filter((item) => item !== reaction));
      toast.current.show({
        severity: 'success',
        summary: 'While deleting reaction',
        detail: 'Successfully deleted reaction',
      });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'While deleting reaction',
        detail: e.message,
      });
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
    deleteAction,
    deleteReaction,
    services,
    users,
    initValues,
    validate,
    submitAction,
    submitReaction,
    deleteAdmin,
    addAdmin,
    toast,
    changeAction,
    changeReaction,
  };
};

export default useSettingsAdmin;
