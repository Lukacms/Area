import '../styles/home.css';
import useHome from '../hooks/useHome';
import { Button } from 'primereact/button';
import { PanelMenu } from 'primereact/panelmenu';
import { Divider } from 'primereact/divider';
import { useNavigate } from 'react-router-dom';
import AreaCard from '../components/AreaCard'

const Home = () => {
  const {dispAct, dispReac, items3, areas, selectedArea} = useHome();
  const navigate = useNavigate();
    console.log("selectedArea in home: ", selectedArea);

  return (
    <div className='globalDiv'>
      <div className='leftDiv'>
      <div className='topLeft'>
        <b className='fastrText'> FastR </b>
        <Button label='setting' onClick={() => navigate('/settings')}/>
      </div>
        <div className='selectButton'>
          <Button label='Actions' onClick={dispAct}/>
          <Button label='Reactions' onClick={dispReac}/>
        </div>
        <Divider />
        <PanelMenu model={items3} className='pannelMenu'/>
      </div>
      <div className='middleDiv'>
      <AreaCard area={selectedArea}/>
      </div>
      <div className='rightDiv'>
      <PanelMenu model={areas} className='pannelMenu' />
      </div>
    </div>
  );
}

export default Home;
