import { BackButton, Background } from '../components';
import '../styles/errors.css';
import '../styles/components.css';

function NotFound() {
  return (
    <Background>
      <div className='app'>
        <BackButton label='Back' path={'/home'} />
        <h1>404 Error</h1>
        <p>
          This URL is unknown. It may be a typo, or the page you're seaching for doesn't exists.
        </p>
      </div>
    </Background>
  );
}

export default NotFound;
