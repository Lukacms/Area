import React, { useState } from 'react';
import useLogin from '../hooks/useLogin';
import { Image } from 'primereact/image';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import '../styles/login.css';

function Login() {
  const { login, navigate } = useLogin();
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');

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
          <Image src={process.env.PUBLIC_URL + 'icon.png'} alt='Image' width='273px' height='186px' className='img' />
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
            <p className='fPassword' onClick={() => navigate('/')}>
              {' '}
              Forget password ?
            </p>
          </label>
          <Button label='Login' className='buttonDiv' left='' onClick={() => login()} />
        </div>
        <div className='divDiv'>
          <hr className='hrMidle' />
        </div>
        <div className='divSignin'>
          <p className='title'>
            <b>Dont have an account ?</b>
          </p>
          <p className='subTitle'> sign up now !</p>
          <Button label='Sign up' className='buttonDiv2' onClick={() => navigate('/register')} />
        </div>
      </div>
    </div>
  );
}

export default Login;
