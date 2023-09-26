import BackButton from '../components/BackButton';
import Background from '../components/Background';
import { Image } from 'primereact/image';
import '../styles/App.css';
import '../styles/signup.css';
import { Divider } from 'primereact/divider';

function Signup() {

  return (
    <Background>
      <div className='App'>
        <BackButton label='Home'/>
        <div className='body'>
          <Image src={process.env.PUBLIC_URL + 'icon.png'} width={400} className='app-logo' />
          <hr className='divider' />
        </div>
      </div>
    </Background>
  );
}

export default Signup;
