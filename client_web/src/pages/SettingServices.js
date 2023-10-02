import { Dialog } from 'primereact/dialog';
import { useNavigate } from 'react-router';
import Home from './Home';
import { useSettingServices } from '../hooks';
import { Button } from 'primereact/button';

function SettingServices() {
  const navigate = useNavigate();
  const { services } = useSettingServices();

  const header = () => {
    return (
      <div className='flex flex-row' style={{width: '110%'}}>
        <Button label='Services' disabled text />
        <Button label='Settings' onClick={() => navigate('/settings')} text />
      </div>
    );
  };

  return (
    <Home>
      <Dialog header={header} visible onHide={() => navigate('/home')} maximizable>
        <p>OUIIIIIIIIIIIIIIIIIIIIIIIIIIII</p>
      </Dialog>
    </Home>
  );
}

export default SettingServices;
