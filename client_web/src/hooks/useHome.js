import { useRef, useState } from 'react';
import { delArea, postArea, postUserAction, postUserReaction, putArea } from '../config/request';
import secureLocalStorage from 'react-secure-storage';

/**
 * Have all methods linked to area making, transformations, ...
 * Is a complement of `useFetchHome` page
 */
const useHome = () => {
  const toast = useRef();
  const areaToast = useRef();
  const [newAreaName, setNewAreaName] = useState('');
  const [errorName, setErrorName] = useState(null);
  const [newAction, setNewAction] = useState({});
  const [newReactions, setNewReactions] = useState([]);
  const [error, setError] = useState(null);
  const [selectedArea, setSelectedArea] = useState(null);

  const validateName = (setStatus, setActionReac) => {
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
      setActionReac('Actions');
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
    if (status === 'GetAction') {
      setStatus('ConfigureAction');
      setNewAction(item);
    } else {
      toast.current.show({severity: 'error', summary: 'Not allowed', detail: 'Create an area to add the action'});
    }
  };

  const setReactionArea = (status, setStatus, item) => {
    if (status === 'GetReactions') {
      setStatus('ConfigureReaction');
      setNewReactions((old) => [...old, item]);
    } else {
      toast.current.show({severity: 'error', summary: 'Not allowed', detail: 'Create an area to add the reaction'});
    }
  };

  const cancelNewAction = (setStatus) => {
    setStatus('GetAction');
    setNewAction({});
  };

  const cancelNewReaction = (setStatus) => {
    setStatus('GetReactions');
    setNewReactions((old) => old.slice(0, -1));
  };

  const changeValueNewReaction = (e, item) => {
    setNewReactions(
      newReactions.map((reaction, index) =>
        index === newReactions.length - 1
          ? { ...reaction, configuration: { ...reaction.configuration, [item]: e.target.value } }
          : reaction,
      ),
    );
  };

  const validateActionReac = (setActionReac, status, setStatus) => {
    var isValid = true;

    setError(null);
    if (status === 'ConfigureAction') {
      Object.entries(newAction.configuration).forEach((item) => {
        if (!item[1]) {
          setError('All fields must be filled');
          isValid = false;
          return;
        }
      });
    } else if (status === 'ConfigureReaction') {
      Object.entries(newReactions[newReactions.length - 1].configuration).forEach((item) => {
        if (!item[1]) {
          setError('All fields must be filled');
          isValid = false;
          return;
        }
      });
    }
    if (error || !isValid) return;
    areaToast.current.show({
      severity: 'success',
      summary: 'Successfully added ' + status === 'ConfigureAction' ? 'action' : 'reaction',
    });
    setStatus('GetReactions');
    setActionReac('Reactions');
    setError(null);
  };

  const changeValueNewAction = (e, item) => {
    setNewAction(
      (old) =>
        [
          {
            ...old,
            configuration: { ...old.configuration, [item]: e.target.value },
          },
        ][0],
    );
  };

  const saveNewArea = async (setTabAreas, setStatus) => {
    try {
      const userId = secureLocalStorage.getItem('userId');
      const createdArea = await postArea({
        userId: userId,
        name: newAreaName,
        favorite: false,
      });
      const action = {
        areaId: createdArea.data.id,
        actionId: newAction.id,
        timer: newAction.timer,
        configuration: newAction.configuration ? JSON.stringify(newAction.configuration) : '{}',
      };
      const reactions = newReactions.map((reaction) => ({
        areaId: createdArea.data.id,
        reactionId: reaction.id,
        configuration: reaction.configuration ? JSON.stringify(reaction.configuration) : '{}',
        reaction: { name: reaction.label },
      }));

      await postUserAction(action);
      for (const reaction of reactions) {
        try {
          await postUserReaction({
            areaId: reaction.areaId,
            reactionId: reaction.reactionId,
            configuration: reaction.configuration ? reaction.configuration : '{}',
          });
        } catch (e) {
          areaToast.current.show({
            severity: 'error',
            summary: 'Could not create Reaction',
            detail: 'Try again in a few minutes',
          });
        }
      }
      setTabAreas((old) => [
        ...old,
        {
          id: createdArea.data.id,
          userId: userId,
          name: newAreaName,
          favorite: false,
          userAction: action,
          userReactions: reactions,
        },
      ]);
      resetAreaMaking(setStatus);
      setSelectedArea(
        [
          {
            id: createdArea.data.id,
            userId: userId,
            name: newAreaName,
            favorite: false,
            userAction: { ...action, name: newAction.label },
            userReactions: reactions,
          },
        ][0],
      );
      areaToast.current.show({
        severity: 'success',
        summary: 'Success',
        detail: 'Area successfully created',
      });
    } catch (e) {
      areaToast.current.show({
        severity: 'error',
        summary: 'Could not create Area',
        detail: 'Try again in a few minutes',
      });
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
    setNewAction,
    newReactions,
    areaToast,
    setActionArea,
    setReactionArea,
    cancelNewAction,
    cancelNewReaction,
    changeValueNewReaction,
    changeValueNewAction,
    saveNewArea,
    error,
    validateActionReac,
    selectedArea,
    setSelectedArea,
  };
};

export default useHome;
