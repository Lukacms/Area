import { Messages } from 'primereact/messages';
import { BackButton, Background } from '../components';
import { useError } from '../hooks';
import '../styles/components.css';

/**
 * Error page. If an error occurs (wrong fetch, ...) the user will be redirected here.
 * @returns {HTMLElement}
 */
function Error() {
  const { error_msgs } = useError();

  return (
    <Background>
      <div className='app'>
        <BackButton label='Back' />
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '5vh' }}>
          <Messages ref={error_msgs} style={{ width: '70vw' }} />
        </div>
      </div>
    </Background>
  );
}

export default Error;
