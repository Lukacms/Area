import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Home } from '..';
import { useSettingServices } from '../../hooks';

/**
 * Settings pages for services ; to handle the connections and oversee all the services that an user could be connected to
 * @returns {HTMLElement}
 */
function SettingServices() {
  const { services, navigate, loaded, isAdmin } = useSettingServices();

  const header = () => {
    return (
      <div className='flex flex-row' style={{ width: '110%' }}>
        <Button label='Services' disabled text severity='info' />
        <Button label='Settings' onClick={() => navigate('/settings')} text severity='info' />
        {isAdmin ? (
          <Button label='Admin' onClick={() => navigate('/settings/admin')} text severity='info' />
        ) : null}
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
          style={{ minWidth: '50%', gap: '5%', justifyContent: 'space-between', paddingLeft: '1vw', paddingRight: '1vw' }}
          raised
          text
          onClick={() => navigate('/settings/services/' + item.id, { state: { item } })}>
          <span>{item.name}</span>
          <i className='pi pi-chevron-right' />
        </Button>
      </div>
    );
  };

  return (
    <Home publicPath='../../'>
      <Dialog
        header={header}
        style={{ minWidth: '30%', minHeight: '40%' }}
        visible
        onHide={() => navigate('/home')}
        maximizable>
        {loaded ? services.map((item) => (item.oauth ? renderItem(item) : null)) : <ProgressSpinner />}
      </Dialog>
    </Home>
  );
}

export default SettingServices;
