import BackButton from '../components/BackButton';
import Background from '../components/Background';
import '../styles/App.css';
import '../styles/signup.css';

function Signup() {

  return (
    <Background>
      <div className='App'>
        <BackButton label='Home' />
      </div>
    </Background>
  );
}

export default Signup;
