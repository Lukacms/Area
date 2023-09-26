import '../styles/login.css';
// import useLogin from '../hooks/useLogin';
import '../styles/App.css';
import {React, useState} from 'react';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';

function Login() {
  const navigate = useNavigate();
  // const {} = useLogin();
  const [Email, setEmail] = useState("");

  return (
    <div className="box">
      <div className="overflow: hidden">
        <div className="CircleBlu" />
        <div className="CircleBlu2" />
        <div className="CircleHollow" />
        <div className="CircleHollow2" />
        <div className="CirclePink" />
        <div className="CirclePink2" />

        <p className='Text'> {Email} </p>
        <div className="App">
          <label className="EmailBox">
            Email:
            <InputText className='TextBox' value={Email} onChange={(e) => setEmail(e.target.value)}/>
          </label>
          <label className="PassBox">Password:</label>
          <Button label='SignUp' onClick={() => navigate('/signup')} />
        </div>
      </div>
    </div>
  );
}

export default Login;
