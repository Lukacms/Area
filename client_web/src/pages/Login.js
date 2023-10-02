import '../styles/login.css';
import useLogin from '../hooks/useLogin';
import { React, useState } from 'react';
import { Image } from 'primereact/image';
import logo from '../FastR 2.png';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';

function Login() {
  const {} = useLogin();
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');
  const navigate = useNavigate();

  function onPress() {
    navigate('/home');
  }

  function onPressForget() {}
  return (
    <div className='box'>
      <div className='CircleBlu' />
      <div className='CircleBlu2' />
      <div className='CircleHollow' />
      <div className='CircleHollow2' />
      <div className='CirclePink' />
      <div className='CirclePink2' />

      <p className='Text'> {email} </p>
      <p className='Text'> {pass} </p>
      <div className='App'>
        <div className='divLogin'>
          <Image src={logo} alt='Image' width='273px' height='186px' className='img' />
          <label className='EmailBox'>
            Email:
            <InputText
              className='TextBox'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder='Enter your email'
            />
          </label>
          <label className='PassBox'>
            Password:
            <InputText
              className='TextBox'
              value={pass}
              onChange={(e) => setPass(e.target.value)}
              type='password'
              placeholder='Enter your password'
            />
            <p className='fPassword' onClick={onPressForget}>
              {' '}
              Forget password ?
            </p>
          </label>
          <Button label='Login' className='buttonDiv' left='' onClick={onPress} />
        </div>
        <div className='divDiv'>
          <hr className='hrMidle' />
        </div>
        <div className='divSignin'>
          <p className='title'>
            <b>Dont have an account ?</b>
          </p>
          <p className='subTitle'> sign up now !</p>
          <Button label='Sign up' className='buttonDiv2' />
        </div>
      </div>
    </div>
  );
}

export default Login;
