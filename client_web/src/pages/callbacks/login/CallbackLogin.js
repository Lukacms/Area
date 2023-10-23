import { Messages } from 'primereact/messages';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Background } from '../../../components';
import { useCallbackLogin } from '../../../hooks';
import '../../../styles/components.css';

function CallbackLogin() {
  const { ref } = useCallbackLogin();

  return (
    <Background>
      <div className='app'>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            paddingTop: '15vh',
          }}>
          <ProgressSpinner style={{ width: '25vh', height: '25vh', marginBottom: '6vh' }} />
          <div className='messages'>
            <Messages ref={ref} />
          </div>
        </div>
      </div>
    </Background>
  );
}

export default CallbackLogin;
