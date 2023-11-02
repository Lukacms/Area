import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { useSpecificService } from '../../hooks';
import { Home } from '..';

/**
 * Information about a specific service. Either allow user to connect or disconnect / change account.
 * @returns {HTMLElement}
 */
function SpecificService() {
  const { navigate, item, connect, changeAccount, disconnect, isAdmin } = useSpecificService();

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

  return (
    <Home publicPath='../../'>
      <Dialog
        header={header}
        style={{ minWidth: '30%', minHeight: '40%' }}
        visible
        onHide={() => navigate('/home')}
        maximizable>
        <Button
          style={{ marginLeft: -10 }}
          label={item?.name ? item?.name : 'No item found'}
          icon='pi pi-chevron-left'
          text
          severity='info'
          onClick={() => navigate(-1)}
        />
        {item?.userConnected ? (
          <p>You are connected to this service.</p>
        ) : (
          <p>You are not connected.</p>
        )}
        {item?.userConnected ? (
          <Button
            label='Change account'
            text
            severity='info'
            size='small'
            onClick={changeAccount}
          />
        ) : (
          <Button label='Connect' text severity='info' size='small' onClick={connect} />
        )}
        <br />
        {item?.userConnected ? (
          <Button label='Log out' text severity='info' size='small' onClick={disconnect} />
        ) : null}
      </Dialog>
    </Home>
  );
}

export default SpecificService;
