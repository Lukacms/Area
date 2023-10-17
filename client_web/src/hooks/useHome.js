import { useEffect, useState } from 'react';
import {
  getServices,
  getUserServices,
  getActionsByServiceId,
  getReactionsByServiceId,
  getUsersAreas,
} from '../config/request';
import secureLocalStorage from 'react-secure-storage';
import { useNavigate } from 'react-router';

const useHome = () => {
  const [stateOfCreation, setStateOfCreation] = useState('Not');
  const navigate = useNavigate();
  const [canSave, setCanSave] = useState(false);
  const [blankArea, setBlankArea] = useState({
    label: '',
    icon: '',
    data: { action: '', reaction: [''], id: 0 },
    command: () => {},
  });
  const [currentSelectedCategory, setCurrentSelectedCategory] = useState('actions');
  const [loading, setLoading] = useState(true);

  const updateCurrentSelectedCategory = (category) => {
    if (category === null) return;
    setCurrentSelectedCategory(category);
  };

  const [currentState, setCurrentState] = useState('If you want to add an area, click on new area');
  /*  const currentStatee = [
    'Please enter a name to the area',
    'Please select an action for the area',
    'Select your reactions, and when you are finished click on save Area',
  ];*/
  const [addAct, setaddAct] = useState(false);
  const [areas, setAreas] = useState([{ action: '', reaction: [''], name: '' }]);
  const [tmpAct, setTmp] = useState('');
  const [selectedArea, setSelectedArea] = useState({
    action: '',
    reaction: '',
    name: '',
  });
  const [panelAreas, setPanelAreas] = useState([
    {
      label: 'favorite',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: '',
          data: { action: '', reaction: [''], id: 0 },
          command: () => {
            clickArea({ areaSelected: 0, favorite: 0 });
          },
        },
      ],
    },
    {
      label: 'Not Favorites',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: '',
          command: () => {
            clickArea({ areaSelected: 0, favorite: 1 });
          },
          data: { action: '', reaction: [''], id: 0 },
        },
      ],
    },
  ]);

  const clickArea = ({ areaSelected, favorite }) => {
    panelAreas[favorite]?.items.forEach((item) => {
      if (item && item.data.id === areaSelected) {
        setSelectedArea({
          name: String(item.label),
          action: String(item.data.action),
          reaction: String(item.data.reaction),
        });
      }
    });
  };

  const [actionList, setActionList] = useState([]);

  const addActionToBlankArea = ({ action }) => {
    // if (stateOfCreation !== 'action') return;
    var tmp = blankArea;
    tmp.data.action = action;
    setBlankArea(tmp);
    setCurrentSelectedCategory('reactions');
    setStateOfCreation('reaction');
    onAddActionArea();
  };

  const clickAct = (eventName) => {
    if (addAct) {
      return;
    }
    setTmp(eventName);
    setaddAct(true);
  };

  const [reactionList, setReactionList] = useState([]);

  const clickReact = (eventName) => {
    if (!addAct) {
      return;
    }
    setaddAct(false);
    areas.push({ action: tmpAct, reaction: eventName, name: 'act' });
    addToPanelArea({
      act: String(areas[areas.length - 1].action),
      name: String(areas[areas.length - 1].name),
      react: String(areas[areas.length - 1].reaction),
    });
  };

  const addToPanelArea = ({ act, react, name, id }) => {
    if (panelAreas[1].items[0].label === '') {
      panelAreas[1].items.pop();
    }
    panelAreas[1].items.push({
      label: name,
      data: {
        action: act,
        reaction: react,
        id: id,
      },
      command: () => {
        clickArea({ areaSelected: id, favorite: 1 });
      },
    });
  };
  const addToPanelFavArea = ({ act, react, name, id }) => {
    if (panelAreas[0].items[0].label === '') {
      panelAreas[0].items.pop();
    }
    panelAreas[0].items.push({
      label: name,
      data: {
        action: act,
        reaction: react.map((item) => {
          return item.configuration;
        }),
        id: id,
      },
      command: () => {
        clickArea({ areaSelected: id, favorite: 0 });
      },
    });
  };

  const [actionOrReaction, setItems] = useState(actionList);
  const dispAct = () => {
    setItems(actionList);
  };
  const dispReac = () => {
    setItems(reactionList);
  };

  const addNameToBlankArea = ({ name }) => {
    var tmp = blankArea;
    blankArea.label = String(name);
    setBlankArea(tmp);
  };

  const addReactionToBlankArea = ({ reaction }) => {
    // if (stateOfCreation !== 'reaction' && stateOfCreation !== '1reaction') return;
    var tmp = blankArea;
    if (tmp.data.reaction[0] === '') {
      tmp.data.reaction[0] = reaction;
    } else tmp.data.reaction.push(reaction);
    setBlankArea(tmp);
    setCanSave(true);
    setStateOfCreation('1reaction');
  };

  const addCreatedAreaToAreas = () => {
    if (stateOfCreation !== '1reaction') return;
    areas.push({
      action: blankArea.data.action,
      reaction: blankArea.data.reaction,
      name: blankArea.label,
    });
    addToPanelArea({
      act: String(areas[areas.length - 1].action),
      name: String(areas[areas.length - 1].name),
      react: String(areas[areas.length - 1].reaction),
    });
    setCanSave(false);
    setCurrentState('If you want to add an area, clik on new area');
    setBlankArea({
      label: '',
      icon: '',
      data: { action: '', reaction: [''], id: 0 },
      command: () => {},
    });
    setStateOfCreation('Not');
  };

  const onClickForCreateArea = () => {
    setCurrentState('Please enter a name to the area');
    setStateOfCreation('name');
  };

  const onEnterNameArea = () => {
    setCurrentState('Please select an action for the area');
    setStateOfCreation('action');
  };

  const onAddActionArea = () => {
    setCurrentState('Select your reactions, and when you are finished click on save Area');
  };

  const addServicesToUser = ({ actions, reactions, name, id }) => {
    if (actions.data && actions.data.length) {
      if (actionList.length && actionList[0].label === '') actionList.pop();
      actionList.push({ label: name, icon: 'pi pi-fw pi-folder', id: id, items: [] });
      for (let i = 0; i < actions.data.length; i++) {
        actionList[actionList.length - 1].items.push({
          label: actions.data[i].name,
          command: () => {
            setCurrentSelectedCategory('reactions');
            addActionToBlankArea({ action: actions.data[i].name });
            onAddActionArea();
          },
        });
      }
    }
    if (reactions.data && reactions.data.length) {
      if (reactionList.length && reactionList[0].label === '') reactionList.pop();
      reactionList.push({ label: name, icon: 'pi pi-fw pi-folder', id: id, items: [] });
      for (let i = 0; i < reactions.data.length; i++) {
        reactionList[reactionList.length - 1].items.push({
          label: reactions.data[i].name,
          command: () => {
            addReactionToBlankArea({ reaction: reactions.data[i].name });
          },
        });
      }
    }
  };

  useEffect(() => {
    const loadDatas = async () => {
      const userId = secureLocalStorage.getItem('userId');

      try {
        const services = await getServices();
        const userServices = await getUserServices(userId);
        const usersAreas = await getUsersAreas(userId);

        for (let i = 0; i < services.data.length; i++) {
          for (let j = 0; j < userServices.data.length; j++) {
            if (services.data[i].id === userServices.data[j].serviceId) {
              addServicesToUser({
                actions: await getActionsByServiceId(services.data[i].id),
                reactions: await getReactionsByServiceId(services.data[i].id),
                name: services.data[i].name,
                id: services.data[i].id,
              });
            }
          }
        }
        if (usersAreas && usersAreas.data.length) {
          usersAreas.data.forEach((item) => {
            if (item.favorite) {
              addToPanelFavArea({
                act: item.userAction?.configuration,
                react: item.reaction.map((react) => react.configuration),
                name: item.name,
                id: item.id,
              });
            } else {
              addToPanelArea({
                act: item.userAction?.configuration,
                react: item.reaction?.map((react) => react.configuration),
                name: item.name,
                id: item.id,
              });
            }
          });
        }
      } catch (e) {
        navigate('/error', { state: { message: e.message } });
      }
      setLoading(false);
    };
    loadDatas();
  }, []);

  return {
    dispAct,
    dispReac,
    actionOrReaction,
    panelAreas,
    selectedArea,
    addNameToBlankArea,
    addCreatedAreaToAreas,
    onClickForCreateArea,
    currentState,
    currentSelectedCategory,
    updateCurrentSelectedCategory,
    onEnterNameArea,
    canSave,
  };
};

export default useHome;

export class Area {
  constructor(label, icon, data) {
    this.label = label;
    this.icon = icon;
    this.data = data;
  }
}
