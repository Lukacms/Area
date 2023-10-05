import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Home } from '../';
import { useCallbackGoogle } from '../../hooks';

function CallbackGoogle() {
  const { navigate, /* success, */ loading } = useCallbackGoogle();

  const header = () => {
    return (
      <div className='flex flex-row' style={{ width: '110%' }}>
        <Button label='Services' disabled text severity='info' />
        <Button label='Settings' onClick={() => navigate('/settings')} text severity='info' />
      </div>
    );
  };

  return (
    <Home>
      <Dialog
        header={header}
        style={{ minWidth: '30%', minHeight: '40%' }}
        visible
        onHide={() => navigate('/home')}>
        {loading ? <ProgressSpinner /> : null}
      </Dialog>
    </Home>
  );
}

export default CallbackGoogle;
