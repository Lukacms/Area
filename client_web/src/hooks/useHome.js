import { useEffect, useState } from 'react';

const useHome = () => {
  let nbArea = 0;
  const [addAct, setaddAct] = useState(false);
  const [area, setArea] = useState([{ action: '', reaction: [''], name: '' }]);
  const [tmpAct, setTmp] = useState('');
  const [selectedArea, setSelectedArea] = useState({ action: '', reaction: [''], name: '' });
  const [areas, setAreas] = useState([
    {
      label: 'favorite',
      items: [
        {
          label: '',
          data: { action: '', reaction: [''], id: 0},
          command: () => {
               clickArea({areaSelected: areas[0].items[0]});
          },

        },
      ],
    },
    {
      label: 'lambda',
      items: [
        {
          label: '',
           command: () => {
               clickArea({areaSelected: areas[1].items[0]});
          },
            data: { action: '', reaction: [''], id: 0 },
        },
      ],
    },
  ]);


    const clickArea = ({areaSelected}) => {
        console.log("clickArea: ", areaSelected);
        setSelectedArea({name: areaSelected.label, action: areaSelected.data.action, reaction: areaSelected.data.reaction})
    }

  const clickAct = (eventName) => {
    if (addAct) {
      /*console.log("Please select a reaction");*/
      return;
    }
    setTmp(eventName);
    setaddAct(true);
  };

  const clickReact = (eventName) => {
    if (!addAct) {
      /*console.log("Please select an action first");*/
      return;
    }
    setaddAct(false);
    area.push({ action: tmpAct, reaction: eventName, name: 'act' });
    addToAreas({
      act: String(area[area.length - 1].action),
      name: String(area[area.length - 1].name),
      react: String(area[area.length - 1].reaction),
    });
  };

  useEffect(() => {
    const areasMod = () => {
      /*for (let i = 0; i < area.length; i++)
        console.log('ff:', area[i].action, ' ', 'gg: ', area[i].reaction);*/
    };
    areasMod();
  }, [area]);

  useEffect(() => {
    const areasMod = () => {
      /*for (let i = 0; i < area.length; i++)
        console.log('ff:', area[i].action, ' ', 'gg: ', area[i].reaction);*/
    };
    areasMod();
  }, [areas]);
  const items = [
    {
      label: 'discord',
      items: [
        {
          label: 'action disc 1',
          command: () => {
            clickAct(items[0].items[0].label);
          },
        },
        {
          label: 'action disc 2',
          command: () => {
            clickAct(items[0].items[1].label);
          },
        },
      ],
    },
    {
      label: 'microsoft',
      items: [
        {
          label: 'action mail1',
          command: () => {
            clickAct(items[1].items[0].label);
          },
        },
        {
          label: 'action mail2',
          command: () => {
            clickAct(items[1].items[1].label);
          },
        },
      ],
    },
  ];

  const items2 = [
    {
      label: 'discord',
      items: [
        {
          label: 'reaction disc 1',
          command: () => {
            clickReact(items2[0].items[0].label);
          },
        },
        {
          label: 'reaction disc 2',
          command: () => {
            clickReact(items2[0].items[1].label);
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
            clickReact(items2[1].items[0].label);
          },
        },
        {
          label: 'reaction mail2',
          command: () => {
            clickReact(items2[1].items[1].label);
          },
        },
      ],
    },
  ];

  const addToAreas = ({ act, react, name }) => {
    if (areas[1].items[0].label === '') {
      areas[1].items.pop();
      areas[1].items.push({ label: name, data: { action: act, reaction: react }, command: () => {
               clickArea({areaSelected: areas[1].items[0]});
      } }
      )
        ;
    } else {
        nbArea++;
      areas[1].items.push({ label: name, data: { action: act, reaction: react }, command: () => {
               clickArea({areaSelected: areas[1].items[nbArea]});
      }});
    }
  };
  const [items3, setItems] = useState(items);

  const dispAct = () => {
    setItems(items);
  };
  const dispReac = () => {
    setItems(items2);
  };
  return { dispAct, dispReac, items3, areas, selectedArea };
};

export default useHome;
