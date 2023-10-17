import { useRef, useState } from 'react';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { ConfirmDialog } from 'primereact/confirmdialog';
import { DataTable } from 'primereact/datatable';
import { Dialog } from 'primereact/dialog';
import { Toast } from 'primereact/toast';
import { AdminAddItem, Background } from '../../components';
import { useSettingsAdmin } from '../../hooks';
import '../../styles/admin.css';
import { Image } from 'primereact/image';
import { Divider } from 'primereact/divider';

function SettingsAdmin() {
  const {
    navigate,
    label,
    setLabel,
    actions,
    reactions,
    deleteAction,
    deleteReaction,
    services,
    users,
    initValues,
    validate,
    submitAction,
    submitReaction,
    deleteAdmin,
    addAdmin,
    toast
  } = useSettingsAdmin();
  const [addAction, setAddAction] = useState(false);
  const [addReaction, setAddReaction] = useState(false);
  const revokeAdmin = useRef();
  const [revoke, setRevoke] = useState(null);

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
              onClick={() => deleteAction(action)}
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
              onClick={() => deleteReaction(reaction)}
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
          visible={revoke != null}
          onHide={() => setRevoke(null)}
          reject={() => setRevoke(null)}
          accept={() => deleteAdmin(revoke)}
          icon='pi pi-exclamation-triangle'
          message='Are you sure you want to proceed ?'
        />
        {user.admin ? (
          <Button
            ref={revokeAdmin}
            label='Revoke admin rights'
            severity='danger'
            onClick={() => setRevoke(user)}
          />
        ) : (
          <Button label='Set admin' severity='success' onClick={() => addAdmin(user)} />
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
    <Background>
      <Toast ref={toast}/>
      <div className='leftPannel'>
        <div className='titleContainer'>
          <Image src={'../' + process.env.PUBLIC_URL + 'partial_icon.png'} width='150' />
          <Button
            rounded
            outlined
            severity='info'
            icon='pi pi-ellipsis-h'
            className='settingsButton'
            onClick={() => navigate('/settings')}
          />
        </div>
        <Divider />
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
    </Background>
  );
}

export default SettingsAdmin;
