import React from 'react';
import BackButton from '../components/BackButton';
import Background from '../components/Background';
import { Image } from 'primereact/image';
import '../styles/App.css';
import '../styles/register.css';
import useRegister from '../hooks/useRegister';
import { Formik, Form, Field } from 'formik';
import { Button } from 'primereact/button';
import FormikInputtext from '../components/FormikInputtext';
import FormikPassword from '../components/FormikPassword';

function Register() {
  const { initialValues, validate, register } = useRegister();

  return (
    <Background>
      <div className='App'>
        <BackButton label='Home' />
        <div className='body'>
          <Image src={process.env.PUBLIC_URL + 'icon.png'} width={400} className='logo' />
          <hr className='divider' />
          <div className='register'>
            <h1>Register</h1>
            <Formik initialValues={initialValues} validate={validate} onSubmit={register} >
              {(props) => (
                <Form>
                  <div className='names'>
                    <Field name='name' type='name' as={FormikInputtext} label='Name' placeholder='Your name' />
                    <Field name='surname' type='surname' as={FormikInputtext} label='Surname' placeholder='Your surname' />
                  </div>
                  <div className='names'>
                    <Field name='username' type='username' as={FormikInputtext} label='Username' placeholder='Username' />
                  </div>
                  <div className='names'>
                    <Field name='email' type='email' as={FormikInputtext} label='Email' placeholder='Email' />
                  </div>
                  <div className='names'>
                    <Field name='password' type='password' as={FormikPassword} label='Password' placeholder='Secure password' toggleMask error={props.errors.passwordCheck} />
                    <Field name='passwordCheck' type='passwordCheck' as={FormikPassword} label='Password' placeholder='Verify your password' toggleMask error={props.errors.passwordCheck} />
                  </div>
                  <Button label='Register' type='submit' />
                </Form>
              )}
            </Formik>
          </div>
        </div>
      </div>
    </Background>
  );
}

export default Register;
