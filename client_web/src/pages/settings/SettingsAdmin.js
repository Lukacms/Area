import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { ConfirmDialog } from 'primereact/confirmdialog';
import { DataTable } from 'primereact/datatable';
import { Dialog } from 'primereact/dialog';
import { AdminAddItem } from '../../components';
import { useSettingsAdmin } from '../../hooks';
import '../../styles/admin.css';
import { useRef, useState } from 'react';

function SettingsAdmin() {
  const {
    navigate,
    label,
    setLabel,
    actions,
    reactions,
    setActions,
    setReactions,
    services,
    users,
    initValues,
    validate,
    submitAction,
    submitReaction,
    deleteAdmin,
    addAdmin
  } = useSettingsAdmin();
  const [addAction, setAddAction] = useState(false);
  const [addReaction, setAddReaction] = useState(false);
  const revokeAdmin = useRef();
  const [revoke, setRevoke] = useState(false);

  const showActions = () => {
    return (
      <DataTable
        value={actions}
        footer={<Button icon='pi pi-plus' rounded onClick={() => setAddAction(true)} />}
        tableStyle={{ minWidth: '60rem' }}>
        <Column field='name' header='Action Name' />
        <Column field='endpoint' header='Endpoint' />
        <Column field='service' header='Service' />
        <Column
          header='Delete'
          body={(action) => (
            <Button
              rounded
              icon='pi pi-minus'
              severity='danger'
              size='small'
              onClick={() => setActions(actions.filter((item) => item !== action))}
            />
          )}
        />
      </DataTable>
    );
  };

  const showReactions = () => {
    return (
      <DataTable
        value={reactions}
        footer={<Button icon='pi pi-plus' rounded onClick={() => setAddReaction(true)} />}
        tableStyle={{ minWidth: '60rem' }}>
        <Column field='name' header='Reaction Name' />
        <Column field='endpoint' header='Endpoint' />
        <Column field='service' header='Service' />
        <Column
          header='Delete'
          body={(reaction) => (
            <Button
              rounded
              icon='pi pi-minus'
              severity='danger'
              size='small'
              onClick={() => setReactions(reactions.filter((item) => item !== reaction))}
            />
          )}
        />
      </DataTable>
    );
  };

  const checkIfAdmin = (user) => {
    return (
      <>
        <ConfirmDialog
          target={revokeAdmin.current}
          visible={revoke}
          onHide={() => setRevoke(false)}
          reject={() => setRevoke(false)}
          accept={() => deleteAdmin(user)}
          icon='pi pi-exclamation-triangle'
          message='Are you sure you want to proceed ?'
        />
        {user.admin ? (
          <Button label='Set admin' severity='success' onClick={() => addAdmin(user)} />
        ) : (
          <Button
            ref={revokeAdmin}
            label='Revoke admin rights'
            severity='danger'
            onClick={() => setRevoke(true)}
          />
        )}
      </>
    );
  };

  const showUsers = () => {
    return (
      <DataTable value={users} tableStyle={{ minWidth: '60rem' }}>
        <Column field='surname' header='Surname' />
        <Column field='name' header='Name' />
        <Column field='username' header='Username' />
        <Column field='email' header='Email' />
        <Column body={checkIfAdmin} header='Is an admin' />
      </DataTable>
    );
  };

  return (
    <div className='globalDiv'>
      <div className='leftDiv'>
        <div className='topLeft'>
          <b className='fastrText' style={{ paddingLeft: '5%' }}>
            FastR
          </b>
          <Button
            rounded
            outlined
            severity='info'
            icon='pi pi-ellipsis-h'
            className='settingsButton'
            onClick={() => navigate('/settings')}
          />
        </div>
        <Button
          label='Home page'
          className='homeButton'
          size='large'
          onClick={() => navigate('/home')}
          style={{ backgroundColor: 'silver', marginLeft: '1vh', marginRight: '1vw' }}
        />
        <Button
          label='Actions'
          size='large'
          text={label !== 'Actions'}
          raised={label !== 'Actions'}
          icon='pi pi-chevron-right'
          iconPos='right'
          onClick={() => setLabel('Actions')}
        />
        <Button
          label='Reactions'
          size='large'
          text={label !== 'Reactions'}
          raised={label !== 'Reactions'}
          icon='pi pi-chevron-right'
          iconPos='right'
          onClick={() => setLabel('Reactions')}
        />
        <Button
          label='Users'
          size='large'
          text={label !== 'Users'}
          raised={label !== 'Users'}
          icon='pi pi-chevron-right'
          iconPos='right'
          onClick={() => setLabel('Users')}
        />
      </div>
      <div className='centerAdmin'>
        {label === 'Actions'
          ? showActions()
          : label === 'Reactions'
          ? showReactions()
          : label === 'Users'
          ? showUsers()
          : null}
        <Dialog
          visible={addAction}
          style={{ width: '30vw' }}
          header='Add new Action'
          resizable={false}
          onHide={() => setAddAction(false)}>
          <AdminAddItem
            initalValues={initValues}
            services={services}
            validate={validate}
            onSubmit={submitAction}
          />
        </Dialog>
        <Dialog
          visible={addReaction}
          style={{ width: '30vw' }}
          header='Add new Reaction'
          resizable={false}
          onHide={() => setAddReaction(false)}>
          <AdminAddItem
            initalValues={initValues}
            services={services}
            validate={validate}
            onSubmit={submitReaction}
          />
        </Dialog>
      </div>
    </div>
  );
}

export default SettingsAdmin;
