import { useEffect, useState } from 'react';

const useHome = () => {
  let nbArea = 0;

  const [blankArea, setBlankArea] = useState({
    label: '',
    icon: '',
    data: { action: '', reaction: [''], id: 0 },
    command: () => {},
  });
  const [addAct, setaddAct] = useState(false);
  const [areas, setArea] = useState([{ action: '', reaction: [''], name: '' }]);
  const [tmpAct, setTmp] = useState('');
  const [selectedArea, setSelectedArea] = useState({ action: '', reaction: [''], name: '' });
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
            clickAct(actionList[0].items[0].label);
          },
        },
        {
          label: 'action disc 2',
          command: () => {
            clickAct(actionList[0].items[1].label);
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
            clickAct(actionList[1].items[0].label);
          },
        },
        {
          label: 'action mail2',
          command: () => {
            clickAct(actionList[1].items[1].label);
          },
        },
      ],
    },
  ];

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
      items: [
        {
          label: 'reaction disc 1',
          command: () => {
            clickReact(reactionList[0].items[0].label);
          },
        },
        {
          label: 'reaction disc 2',
          command: () => {
            clickReact(reactionList[0].items[1].label);
          },
        },
      ],
    },
    {
      label: 'microsoft',
      items: [
        {
          label: 'reaction mail1',
          command: () => {
            clickReact(reactionList[1].items[0].label);
          },
        },
        {
          label: 'reaction mail2',
          command: () => {
            clickReact(reactionList[1].items[1].label);
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
    blankArea.label = name;
    setBlankArea(tmp);
  };

  const addActionToBlankArea = ({ action }) => {
    var tmp = blankArea;
    blankArea.action = action;
    setBlankArea(tmp);
  };

  const addReactionToBlankArea = ({ Reaction }) => {
    var tmp = blankArea;
    blankArea.Reaction = Reaction;
    setBlankArea(tmp);
  };

  const addCreatedAreaToAreas = () => {
    areas.push({
      action: blankArea.data.action,
      reaction: blankArea.data.action,
      name: blankArea.label,
    });
    addToPanelArea({
      act: String(areas[areas.length - 1].action),
      name: String(areas[areas.length - 1].name),
      react: String(areas[areas.length - 1].reaction),
    });
  };

  return { dispAct, dispReac, actionOrReaction, panelAreas, selectedArea };
};

export default useHome;
