import { ProgressSpinner } from 'primereact/progressspinner';
import { BackButton, Background } from '../components';
import { useMailVerif } from '../hooks';
import '../styles/components.css';

/**
 * Page that is used to check email of user. A link to this page is sent in an email after account creation
 * @returns {HTMLElement}
 */
function MailVerif() {
  const { verified, error } = useMailVerif();

  return (
    <Background>
      <div className='app'>
        <BackButton label='Back' path='/' />
        <div style={{ display: 'flex', justifyContent: 'flex-start', marginTop: '5vh', marginLeft: '5vw' }}>
          {!verified ? (
            <ProgressSpinner />
          ) : error ? (
            error
          ) : (
            <div>
              Account successfully verified. Click <a href='/'>Here</a> to log in again
            </div>
          )}
        </div>
      </div>
    </Background>
  );
}

export default MailVerif;
