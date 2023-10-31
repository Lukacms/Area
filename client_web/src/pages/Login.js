import React from 'react';
import { Image } from 'primereact/image';
import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { Formik, Form, Field } from 'formik';
import { useLogin } from '../hooks/';
import { Background, FormikInputtext, FormikPassword } from '../components';
import '../styles/login.css';

function Login() {
  const { loginUser, navigate, initialValues, validate, loading, error, setError, googleSignIn } =
    useLogin();

  return (
    <Background>
      <div className='App'>
        <div className='divLogin'>
          <Image
            src={process.env.PUBLIC_URL + 'icon.png'}
            alt='Image'
            width='273px'
            height='186px'
            className='img'
          />
          <Button
            icon='pi pi-google'
            label='Sign in with google'
            className='googleSignIn'
            size='large'
            outlined
            onClick={() => googleSignIn()}
          />
          <div className='subTitle'>or</div>
          <Formik initialValues={initialValues} validationSchema={validate} onSubmit={loginUser}>
            {(props) => (
              <Form>
                <div className='signInContainer'>
                  <div className='textBox'>
                    <Field
                      name='email'
                      type='email'
                      as={FormikInputtext}
                      label='Email'
                      placeholder='Your email'
                      error={props.errors?.email}
                      touched={props.touched?.email}
                      icon='pi pi-envelope'
                    />
                  </div>
                  <div className='textBox'>
                    <Field
                      name='password'
                      type='password'
                      as={FormikPassword}
                      label='Password'
                      placeholder='Your password'
                      toggleMask
                      feedback={false}
                      error={props.errors?.password}
                      touched={props.touched?.password}
                    />
                  </div>
                  <Button
                    label='I forgot my password'
                    link
                    size='small'
                    severity='info'
                    type='button'
                    onClick={() => navigate('/login#forgot')}
                  />
                  <Button
                    label='Log In'
                    type='submit'
                    icon={loading ? 'pi' : 'pi pi-check'}
                    iconPos='right'
                    className='buttonDiv'
                  />
                </div>
              </Form>
            )}
          </Formik>
        </div>
        <div className='divDiv'>
          <hr className='hrMidle' />
        </div>
        <div className='divSignin'>
          <div className='title'>
            <b>Don't have an account ?</b>
          </div>
          <div className='subTitle'>Sign up now !</div>
          <Button
            label='Sign up'
            size='large'
            text
            raised
            className='buttonDiv2'
            icon='pi pi-chevron-right'
            iconPos='right'
            onClick={() => navigate('/register')}
          />
        </div>
      </div>
      <Dialog header='Failure' visible={error ? true : false} onHide={() => setError(null)}>
        <span>{error}</span>
      </Dialog>
    </Background>
  );
}

export default Login;
