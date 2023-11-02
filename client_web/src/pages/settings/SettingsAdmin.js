import { useRef, useState } from 'react';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { ConfirmDialog } from 'primereact/confirmdialog';
import { DataTable } from 'primereact/datatable';
import { Dialog } from 'primereact/dialog';
import { Toast } from 'primereact/toast';
import { Image } from 'primereact/image';
import { Divider } from 'primereact/divider';
import { AdminAddItem, Background } from '../../components';
import { useSettingsAdmin } from '../../hooks';
import '../../styles/admin.css';

/**
 * Page accessible only by admin people. Allow them to modify users, actions and reactions
 * @returns {HTMLElement}
 */
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
    toast,
    changeAction,
    changeReaction,
  } = useSettingsAdmin();
  const [addAction, setAddAction] = useState(false);
  const [addReaction, setAddReaction] = useState(false);
  const revokeAdmin = useRef();
  const [revoke, setRevoke] = useState(null);
  const [selectedAction, setSelectedAction] = useState(null);
  const [selectedReaction, setSelectedReaction] = useState(null);

  const findServiceFromName = (name) => {
    var service = {};

    services.forEach((item) => {
      console.log(item, name);
      if (item.name === name) {
        service = item;
        return;
      }
    });
    return service;
  };

  const showActions = () => {
    return (
      <DataTable
        value={actions}
        footer={<Button icon='pi pi-plus' rounded onClick={() => setAddAction(true)} />}
        tableStyle={{ minWidth: '60rem' }}>
        <Column field='name' header='Action Name' />
        <Column field='endpoint' header='Endpoint' />
        <Column field='service' header='Service' />
        <Column field='description' header='Description' />
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
        <Column
          header='Modify'
          body={(action) => (
            <Button
              rounded
              icon='pi pi-pencil'
              size='small'
              onClick={() =>
                setSelectedAction({
                  ...action,
                  service: findServiceFromName(action.service),
                  defaultConfig: action.defaultConfiguration
                    ? Object.keys(JSON.parse(action.defaultConfiguration)).map(function (key, _) {
                        return key;
                      })
                    : [],
                })
              }
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
        <Column field='description' header='Description' />
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
        <Column
          header='Modify'
          body={(reaction) => (
            <Button
              rounded
              icon='pi pi-pencil'
              size='small'
              onClick={() =>
                setSelectedReaction({
                  ...reaction,
                  service: findServiceFromName(reaction.service),
                  defaultConfig: reaction.defaultConfiguration
                    ? Object.keys(JSON.parse(reaction.defaultConfiguration)).map(function (key, _) {
                        return key;
                      })
                    : [],
                })
              }
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
      <DataTable value={users} tableStyle={{ minWidth: '60rem' }} removableSort>
        <Column field='surname' header='Surname' sortable />
        <Column field='name' header='Name' sortable />
        <Column field='username' header='Username' sortable />
        <Column field='email' header='Email' sortable />
        <Column body={checkIfAdmin} header='Is an admin' />
      </DataTable>
    );
  };

  return (
    <Background>
      <div className='globalDiv'>
        <Toast ref={toast} />
        <div className='leftDiv'>
          <div className='topLeft'>
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
            style={{ backgroundColor: 'silver' }}
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
          <Dialog
            visible={selectedAction}
            style={{ width: '30vw' }}
            header='Change Action'
            resizable={false}
            onHide={() => setSelectedAction(null)}>
            <AdminAddItem
              initalValues={selectedAction}
              services={services}
              validate={validate}
              onSubmit={changeAction}
            />
          </Dialog>
          <Dialog
            visible={selectedReaction}
            style={{ width: '30vw' }}
            header='Change Reaction'
            resizable={false}
            onHide={() => setSelectedReaction(null)}>
            <AdminAddItem
              initalValues={selectedReaction}
              services={services}
              validate={validate}
              onSubmit={changeReaction}
            />
          </Dialog>
        </div>
      </div>
    </Background>
  );
}

export default SettingsAdmin;
