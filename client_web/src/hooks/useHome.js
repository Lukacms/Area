import { useEffect, useState } from 'react';
import {
  getServices,
  getUserServices,
  getActions,
  getActionsByServiceId,
  getReactions,
  getReactionsByServiceId,
} from '../config/request';
import secureLocalStorage from 'react-secure-storage';
import { useNavigate } from 'react-router';

const useHome = () => {
  let nbArea = 0;
  const navigate = useNavigate();
  const [canSave, setCanSave] = useState(false);
  const [blankArea, setBlankArea] = useState({
    label: '',
    icon: '',
    data: { action: '', reaction: [''], id: 0 },
    command: () => {},
  });
  const [currentSelectedCategory, setCurrentSelectedCategory] = useState('actions');

  const updateCurrentSelectedCategory = (category) => {
    setCurrentSelectedCategory(category);
  };

  const [currentState, setCurrentState] = useState(
    'Si vous voulez ajouter une area, clicker sur add area',
  );
  /*  const currentStatee = [
    'Please enter a name to the area',
    'Please select an action for the area',
    'Select your reactions, and when you are finished click on save Area',
  ];*/
  const [addAct, setaddAct] = useState(false);
  const [areas, setArea] = useState([{ action: '', reaction: [''], name: '' }]);
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
            clickArea({ areaSelected: panelAreas[0].items[0] });
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
            clickArea({ areaSelected: panelAreas[1].items[0] });
          },
          data: { action: '', reaction: [''], id: 0 },
        },
      ],
    },
  ]);

  const clickArea = ({ areaSelected }) => {
    console.log('clickArea: ', areaSelected);
    setSelectedArea({
      name: areaSelected.label,
      action: areaSelected.data.action,
      reaction: areaSelected.data.reaction,
    });
  };

  const actionList = [
    {
      label: 'discord',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: 'action disc 1',
          command: () => {
            //clickAct(actionList[0].items[0].label);
            setCurrentSelectedCategory('reactions');
            addActionToBlankArea({ action: actionList[0].items[0].label });
            onAddActionArea();
          },
        },
        {
          label: 'action disc 2',
          command: () => {
            setCurrentSelectedCategory('reactions');
            //clickAct(actionList[0].items[1].label);
            addActionToBlankArea({ action: actionList[0].items[1].label });
            onAddActionArea();
          },
        },
      ],
    },
    {
      label: 'microsoft',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: 'action mail1',
          command: () => {
            setCurrentSelectedCategory('reactions');
            //clickAct(actionList[1].items[0].label);
            addActionToBlankArea({ action: actionList[1].items[0].label });
            onAddActionArea();
          },
        },
        {
          label: 'action mail2',
          command: () => {
            setCurrentSelectedCategory('reactions');
            //clickAct(actionList[1].items[1].label);
            addActionToBlankArea({ action: actionList[1].items[1].label });
            onAddActionArea();
          },
        },
      ],
    },
  ];

  const addActionToBlankArea = ({ action }) => {
    console.log('actiontoblk: ', action);
    var tmp = blankArea;
    tmp.data.action = action;
    setBlankArea(tmp);
  };

  const clickAct = (eventName) => {
    if (addAct) {
      /*console.log("Please select a reaction");*/
      return;
    }
    setTmp(eventName);
    setaddAct(true);
  };

  const reactionList = [
    {
      label: 'discord',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: 'reaction disc 1',
          command: () => {
            //clickReact(reactionList[0].items[0].label);
            console.log('GGGGGGGG: ', reactionList[0].items[0].label);
            addReactionToBlankArea({
              reaction: reactionList[0].items[0].label,
            });
          },
        },
        {
          label: 'reaction disc 2',
          command: () => {
            //clickReact(reactionList[0].items[1].label);
            addReactionToBlankArea({
              reaction: reactionList[0].items[1].label,
            });
          },
        },
      ],
    },
    {
      label: 'microsoft',
      icon: 'pi pi-fw pi-folder',
      items: [
        {
          label: 'reaction mail1',
          command: () => {
            //clickReact(reactionList[1].items[0].label);
            addReactionToBlankArea({
              reaction: reactionList[1].items[0].label,
            });
          },
        },
        {
          label: 'reaction mail2',
          command: () => {
            //clickReact(reactionList[1].items[1].label);
            addReactionToBlankArea({
              reaction: reactionList[1].items[1].label,
            });
          },
        },
      ],
    },
  ];

  const clickReact = (eventName) => {
    if (!addAct) {
      /*console.log("Please select an action first");*/
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
  const addToPanelArea = ({ act, react, name }) => {
    if (panelAreas[1].items[0].label === '') {
      console.log('addtoPAnelARea: ', act, ' ', react, ' ', name);
      panelAreas[1].items.pop();
      panelAreas[1].items.push({
        label: name,
        data: { action: act, reaction: react },
        command: () => {
          clickArea({ areaSelected: panelAreas[1].items[0] });
        },
      });
    } else {
      nbArea++;
      panelAreas[1].items.push({
        label: name,
        data: { action: act, reaction: react },
        command: () => {
          clickArea({ areaSelected: panelAreas[1].items[nbArea] });
        },
      });
    }
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
    var tmp = blankArea;

    console.log('reaction:fff', reaction);
    if (tmp.data.reaction[0] === '') {
      tmp.data.reaction[0] = reaction;
    } else tmp.data.reaction.push(reaction);
    setBlankArea(tmp);
    setCanSave(true);
  };

  const addCreatedAreaToAreas = () => {
    console.log('action: ', blankArea.data.action);
    console.log('reaction: ', String(blankArea.data.reaction[0]));
    areas.push({
      action: blankArea.data.action,
      reaction: blankArea.data.reaction,
      name: blankArea.label,
    });
    console.log('addCreatedArea: ', areas[areas.length - 1]);
    addToPanelArea({
      act: String(areas[areas.length - 1].action),
      name: String(areas[areas.length - 1].name),
      react: String(areas[areas.length - 1].reaction),
    });
    setCanSave(false);
    setCurrentState('Si vous voulez ajouter une area, clicker sur add area');
  };

  const onClickForCreateArea = () => {
    setCurrentState('Please enter a name to the area');
  };

  const onEnterNameArea = () => {
    setCurrentState('Please select an action for the area');
  };

  const onAddActionArea = () => {
    setCurrentState('Select your reactions, and when you are finished click on save Area');
  };

  const addServicesToUser = ({ actions, reactions, name }) => {
    var tmpActionList = actionList;
    var tmpReactionList = reactionList;

    if (actions !== []) {
      if (tmpActionList[0].label === '') tmpActionList.pop();
      tmpActionList.push({ label: name });
      for (let i = 0; i < actions.length; i++) {
        tmpActionList[tmpActionList.length - 1].items.push({
          label: actions[i].name,
          command: () => {
            setCurrentSelectedCategory('reactions');
            addActionToBlankArea({ action: actions[i].name });
            onAddActionArea();
          },
        });
      }
    }
    if (reactions !== []) {
      if (tmpReactionList[0].label === '') tmpReactionList.pop();
      tmpReactionList.push({ label: name });
      for (let i = 0; i < reactions.length; i++) {
        tmpReactionList[tmpReactionList.length - 1].items.push({
          label: actions[i].name,
          command: () => {
            setCurrentSelectedCategory('reactions');
            addReactionToBlankArea({ reaction: reactions[i].name });
          },
        });
      }
    }
  };

  useEffect(async () => {
    try {
      const userId = secureLocalStorage.getItem('userId');
      const services = await getServices();
      const userServices = await getUserServices(userId);

      for (let i = 0; i < services.data.length; i++) {
        for (let j = 0; j < userServices.data.length; j++)
          if (services.data[i].id === userServices.data[j].id) {
            addServicesToUser({
              actions: await getActionsByServiceId(services.data[i].id),
              reactions: await getReactionsByServiceId(services.data[i].id),
              name: services.data[i].name,
            });
          }
      }
    } catch (e) {
      navigate('/error', { state: { message: e.message } });
    }
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
