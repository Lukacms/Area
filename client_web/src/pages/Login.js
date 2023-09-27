import '../styles/login.css';
import useLogin from '../hooks/useLogin';
import '../styles/App.css';
import { React, useState } from 'react';
import { Image } from 'primereact/image';
import logo from '../FastR 2.png';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';

function Login() {
  const {} = useLogin();
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
        <Image src={logo} alt='Image' className='Img' width='272px' height='186px' />
        <div className='divLogin'>
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
          </label>
          <Button label='Login' className='buttonDiv' />
        </div>
      </div>
      <hr className='hrMidle' />
    </div>
  );
}

export default Login;
