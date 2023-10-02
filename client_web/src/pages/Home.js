import useHome from '../hooks/useHome';
import { useEffect, useState } from 'react';
import { Button } from 'primereact/button';
import { PanelMenu } from 'primereact/panelmenu';
import { Divider } from 'primereact/divider';
import '../styles/home.css';

function Home() {
  const {} = useHome();
  const [addAct, setaddAct] = useState(false);
  const [area, setArea] = useState([{ action: '', reaction: '' }]);
  const [tmpAct, setTmp] = useState('');

  const clickAct = (eventName) => {
    if (addAct) {
      console.log('Please select a reaction');
      return;
    }
    setTmp(eventName);
    setaddAct(true);
  };

  const clickReact = (eventName) => {
    if (!addAct) {
      console.log('Please select an action first');
      return;
    }
    area.push({ action: tmpAct, reaction: eventName });
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
      console.log(area);
      console.log('area length: ', area.length);
      for (let i = 0; i < area.length; i++)
        console.log('ff:', area[i].action, ' ', 'gg: ', area[i].reaction);
    };
    areaMod();
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

  function fffff() {
    console.log('gg');
  }

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

  const [items3, setItems] = useState(items);

  function dispAct() {
    setItems(items);
  }
  function dispReac() {
    setItems(items2);
  }

  function onDragEnd(e) {
    console.log(e);
  }

  return (
    <div className='globalDiv'>
      <div className='leftDiv'>
        <b className='fastrText'> FastR </b>
        <div className='selectButton'>
          <Button label='Actions' onClick={dispAct} />
          <Button label='Reactions' onClick={dispReac} />
        </div>
        <Divider />
        <PanelMenu
          model={items3}
          className='pannelMenu'
          onDragEnd={(e) => {
            onDragEnd(e.target.dispatchEvent);
          }}
        />
      </div>
      <div className='middleDiv'></div>
      <div className='rightDiv'></div>
    </div>
  );
}

export default Home;
