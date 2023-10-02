import { useEffect, useState } from 'react';

const useHome = () => {
  const [addAct, setaddAct] = useState(false);
  const [area, setArea] = useState([{ action: '', reaction: '', name: '' }]);
  const [tmpAct, setTmp] = useState('');
  const [selectedArea, setSelectedArea] = useState({action: '', reaction: ''});

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
      console.log("Please select an action first");
      return;
    }
    area.push({ action: tmpAct, reaction: eventName, name: "act" });
    setaddAct(false);
  };

  useEffect(() => {
    const tmpActMod = () => {
      console.log(tmpAct);
    };
    const addActMod = () => {
      console.log(addAct);
    };
    tmpActMod();
    addActMod();
  }, [clickAct]);

  useEffect(() => {
    const areaMod = () => {
        console.log("area: ", area);
      /*for (let i = 0; i < area.length; i++)
        console.log('ff:', area[i].action, ' ', 'gg: ', area[i].reaction);*/
    };
    areaMod();
    addToAreas(area[area.length - 1]);
  }, [clickReact]);

  const items = [
    {
      label: 'discord',
      items: [
        {
          label: 'action disc 1',
          command: (event) => {
            clickAct(items[0].items[0].label);
          },
        },
        {
          label: 'action disc 2',
          command: (event) => {
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
          command: (event) => {
            clickAct(items[1].items[0].label);
          },
        },
        {
          label: 'action mail2',
          command: (event) => {
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
          command: (event) => {
            clickReact(items2[0].items[0].label);
          },
        },
        {
          label: 'reaction disc 2',
          command: (event) => {
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
          command: (event) => {
            clickReact(items2[1].items[0].label);
          },
        },
        {
          label: 'reaction mail2',
          command: (event) => {
            clickReact(items2[1].items[1].label);
          },
        },
      ],
    },
  ];

  const areas = [
      {
          label: "fav",
          items: [
              {
                  label: "",
                  data: {action: "", reaction: ""}
              }
          ]
      },
      {
          label: "not fav",
          items: [
              {
                  label: "",
                  data: {action: "", reaction: ""}
              }
          ]
      }
  ]

    const addToAreas = ({act, react, name}) => {
        if (areas[1].items[0].label === "") {
            areas[1].items.pop();
            areas[1].items.push({label: name, data: {action: act, reaction: react}});
        } else {
            areas[1].items.push({label: name, data: {action: act, reaction: react}});
        }
    }

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
