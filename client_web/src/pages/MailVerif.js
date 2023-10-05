import { Background } from '../components';
import { useMailVerif } from '../hooks';
import '../styles/App.css';

function MailVerif() {
  const { /* verified, */ id } = useMailVerif();

  return (
    <Background>
      <div className='App'>
        <h1>{id}</h1>
    </div>
    </Background>
  );
}

export default MailVerif;
