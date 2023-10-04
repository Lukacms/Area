import React from 'react';
import { Image } from 'primereact/image';
import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { Formik, Form, Field } from 'formik';
import { useLogin } from '../hooks/';
import { Background, FormikInputtext, FormikPassword } from '../components';
import '../styles/login.css';

function Login() {
  const { loginUser, navigate, initialValues, validate, loading, error, setError } = useLogin();

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
          <Formik initialValues={initialValues} validationSchema={validate} onSubmit={loginUser}>
            {(props) => (
              <Form>
                <div className='textBox'>
                  <Field
                    name='email'
                    type='email'
                    as={FormikInputtext}
                    label='Email'
                    placeholder='Your email'
                    error={props.errors?.email}
                    touched={props.touched?.email}
                  />
                </div>
                <div className='textBox'>
                  <Field
                    name='password'
                    type='password'
                    as={FormikPassword}
                    label='Password'
                    placeholder='Your password'
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
                <br />
                <br />
                <Button
                  label='Log In'
                  type='submit'
                  icon={loading ? 'pi' : 'pi pi-check'}
                  iconPos='right'
                  className='buttonDiv'
                />
              </Form>
            )}
          </Formik>
        </div>
        <div className='divDiv'>
          <hr className='hrMidle' />
        </div>
        <div className='divSignin'>
          <p className='title'>
            <b>Dont have an account ?</b>
          </p>
          <p className='subTitle'>Sign up now !</p>
          <Button
            label='Sign up'
            size='large'
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
