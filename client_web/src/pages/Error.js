import { Messages } from 'primereact/messages';
import { BackButton, Background } from '../components';
import { useError } from '../hooks';
import '../styles/components.css';

function Error() {
  const { error_msgs } = useError();

  return (
    <Background>
      <div className='app'>
        <BackButton label='Back' path={'/home'} />
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '5vh' }}>
          <Messages ref={error_msgs} style={{ width: '70vw' }} />
        </div>
      </div>
    </Background>
  );
}

export default Error;
