import { Dialog } from 'primereact/dialog';
import { Home } from '..';
import { useSettingsUser } from '../../hooks';
import { Button } from 'primereact/button';
import { ConfirmPopup } from 'primereact/confirmpopup';
import { Form, Formik, Field } from 'formik';
import { FormikPassword } from '../../components';
import '../../styles/settings.css';
import { useState } from 'react';

function SettingsUser() {
  const { navigate, passwordValues, validation, changePassword, logout, buttonEl, isAdmin } =
    useSettingsUser();
  const [visible, setVisible] = useState(false);

  const header = () => {
    return (
      <div className='flex flex-row' style={{ width: '110%' }}>
        <Button label='Services' onClick={() => navigate('services')} text severity='info' />
        <Button label='Settings' text severity='info' disabled />
        {isAdmin ? (
          <Button label='Admin' onClick={() => navigate('/settings/admin')} text severity='info' />
        ) : null}
      </div>
    );
  };

  return (
    <Home>
      <Dialog
        header={header}
        style={{ minWidth: '30%', minHeight: '40%' }}
        visible
        onHide={() => navigate('/home')}
        maximizable>
        <div className=''>
          <Formik
            initialValues={passwordValues}
            validationSchema={validation}
            onSubmit={changePassword}>
            {(props) => (
              <Form>
                <p style={{ textAlign: 'start', display: 'flex' }}>Change your password.</p>
                <div className='formikInput'>
                  <Field
                    name='password'
                    type='password'
                    as={FormikPassword}
                    label='Password'
                    placeholder='New password'
                    toggleMask
                    error={props.errors?.password}
                    touched={props.touched?.password}
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
                    touched={props.touched?.passwordCheck}
                    feedback={false}
                  />
                </div>
                <Button label='Change Password' type='submit' />
              </Form>
            )}
          </Formik>
        </div>
        <Button
          ref={buttonEl}
          className='logout'
          label='Log out'
          severity='danger'
          onClick={() => setVisible(true)}
        />
        <ConfirmPopup
          target={buttonEl.current}
          visible={visible}
          onHide={() => setVisible(false)}
          message='Are you sure you want to proceed?'
          icon='pi pi-exclamation-triangle'
          accept={logout}
          reject={() => setVisible(false)}
        />
      </Dialog>
    </Home>
  );
}

export default SettingsUser;
