import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { Image } from 'primereact/image';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Home } from '.';
import { useSettingServices } from '../hooks';

function SettingServices() {
  const { services, navigate, loaded } = useSettingServices();

  const header = () => {
    return (
      <div className='flex flex-row' style={{ width: '110%' }}>
        <Button label='Services' disabled text severity='info' />
        <Button label='Settings' onClick={() => navigate('/settings')} text severity='info' />
      </div>
    );
  };

  const renderItem = (item) => {
    return (
      <div style={{ display: 'flex', marginBottom: '10px' }} key={item.id}>
        <Button
          severity='info'
          icon={item.userConnected ? 'pi pi-check' : 'pi pi-times'}
          className='gap-10'
          style={{ minWidth: '50%', gap: '5%', justifyContent: 'space-evenly' }}
          raised
          text
          onClick={() => navigate('/settings/services/' + item.id, { state: { item } })}>
          <Image src={`data:image/png;base64,${item.logo}`} width={50} alt='logo' />
          <span>{item.name}</span>
          <i className='pi pi-chevron-right' />
        </Button>
      </div>
    );
  };

  return (
    <Home>
      <Dialog
        header={header}
        style={{ minWidth: '30%', minHeight: '40%' }}
        visible
        onHide={() => navigate('/home')}
        maximizable>
        {loaded ? services.map((item) => renderItem(item)) : <ProgressSpinner />}
      </Dialog>
    </Home>
  );
}

export default SettingServices;
