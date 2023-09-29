import React from 'react';
import { Image } from 'primereact/image';
import { Formik, Form, Field } from 'formik';
import { Button } from 'primereact/button';
import { Divider } from 'primereact/divider';
import { Dialog } from 'primereact/dialog';
import { FormikPassword, FormikInputtext, BackButton, Background } from '../components';
import { useRegister } from '../hooks';
import '../styles/App.css';
import '../styles/register.css';

function Register() {
  const { initialValues, validate, register, dialogue, setDialogue } = useRegister();

  return (
    <Background>
      <div className='App'>
        <BackButton label='Home' />
        <div className='body'>
          <Image src={process.env.PUBLIC_URL + 'icon.png'} width={400} className='logo' />
          <Divider layout='vertical' align='center' className='divider' />
          <div className='register'>
            <h1>Register</h1>
            <Formik initialValues={initialValues} validationSchema={validate} onSubmit={register}>
              {(props) => (
                <Form>
                  <div className='names'>
                    <Field
                      name='name'
                      type='name'
                      as={FormikInputtext}
                      label='Name'
                      placeholder='Your name'
                      error={props.errors?.name}
                      touched={props.touched.name}
                    />
                    <Field
                      name='surname'
                      type='surname'
                      as={FormikInputtext}
                      label='Surname'
                      placeholder='Your surname'
                      error={props.errors?.surname}
                      touched={props.touched.surname}
                    />
                  </div>
                  <div className='names'>
                    <Field
                      name='username'
                      type='username'
                      as={FormikInputtext}
                      label='Username'
                      placeholder='Username'
                      error={props.errors?.username}
                      touched={props.touched.username}
                    />
                  </div>
                  <div className='names'>
                    <Field
                      name='email'
                      type='email'
                      as={FormikInputtext}
                      label='Email'
                      placeholder='Email'
                      error={props.errors?.email}
                      touched={props.touched.email}
                    />
                  </div>
                  <div className='names'>
                    <Field
                      name='password'
                      type='password'
                      as={FormikPassword}
                      label='Password'
                      placeholder='Secure password'
                      toggleMask
                      error={props.errors?.password}
                      touched={props.touched.password}
                      promptLabel='Choose a password'
                      weakLabel='too weak'
                      mediumLabel='average'
                      strongLabel='Complex password'
                    />
                    <Field
                      name='passwordCheck'
                      type='passwordCheck'
                      as={FormikPassword}
                      label='Password verification'
                      placeholder='Verify your password'
                      toggleMask
                      error={props.errors?.passwordCheck}
                      touched={props.touched.passwordCheck}
                      feedback={false}
                    />
                  </div>
                  <Button
                    label='Register'
                    type='submit'
                    size='large'
                    style={{ paddingLeft: '10%', paddingRight: '10%' }}
                  />
                </Form>
              )}
            </Formik>
            <Dialog header='Failure' visible={dialogue} onHide={() => setDialogue(false)}>
              <p>Failed to create your account. Try again in a few minutes.</p>
            </Dialog>
          </div>
        </div>
      </div>
    </Background>
  );
}

export default Register;
