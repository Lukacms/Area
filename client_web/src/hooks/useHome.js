import { useRef, useState } from 'react';
import { delArea, putArea } from '../config/request';

const useHome = () => {
  const toast = useRef();
  const areaToast = useRef();
  const [newAreaName, setNewAreaName] = useState('');
  const [errorName, setErrorName] = useState(null);
  const [newAction, setNewAction] = useState({});
  const [newReactions, setNewReactions] = useState([]);

  const validateName = (setStatus) => {
    if (!newAreaName || newAreaName.length < 3 || newAreaName.length > 50) {
      setErrorName('Invalid name of Area. Must be between 3 and 50 characters.');
    } else {
      setStatus('GetAction');
      areaToast.current.show({
        severity: 'success',
        summary: 'Success',
        detail: 'Now select an Action',
      });
      setErrorName(null);
    }
  };

  const resetAreaMaking = (setStatus) => {
    setErrorName(null);
    setNewAreaName('');
    setNewAction({});
    setNewReactions([]);
    setStatus('Default');
  };

  const resetAreaName = (setStatus) => {
    setStatus('Default');
    setErrorName(null);
  };

  const changeAreaStatus = async (area, tabAreas, setTabAreas) => {
    try {
      await putArea({
        id: area.id,
        name: area.name,
        userId: area.userId,
        favorite: !area.favorite,
      });
      setTabAreas(
        tabAreas.map((item) =>
          item.id === area.id ? { ...item, favorite: !area.favorite } : item,
        ),
      );
      toast.current.show({ severity: 'success', summary: 'Success' });
    } catch (e) {
      toast.current.show({
        severity: 'error',
        summary: 'Could not change Area',
        detail: e.message,
      });
    }
  };

  const deleteArea = async (area, tabAreas, setTabAreas) => {
    try {
      await delArea(area.id);
      setTabAreas(tabAreas.filter((item) => item.id !== area.id));
      toast.current.show({ severity: 'success', summary: 'Successfully deleted' });
    } catch (e) {
      toast.current.show({ severity: 'error', summary: 'Error', detail: e.message });
    }
  };

  const setActionArea = (status, setStatus, item) => {
    console.log(newAreaName);
    if (status === 'GetAction') {
      setStatus('ConfigureAction');
      setNewAction(item);
    }
  };

  const setReactionArea = (status, setStatus, item) => {
    if (status === 'GetReactions') {
      setStatus('ConfigureReaction');
      setNewAction((old) => [...old, item]);
    }
  };

  return {
    toast,
    changeAreaStatus,
    newAreaName,
    setNewAreaName,
    errorName,
    validateName,
    resetAreaName,
    deleteArea,
    resetAreaMaking,
    newAction,
    newReactions,
    areaToast,
    setActionArea,
    setReactionArea,
  };
};

export default useHome;
