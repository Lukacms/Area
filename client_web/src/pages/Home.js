import { useState } from 'react';
import { Background, PanelAccordion } from '../components';
import { Button } from 'primereact/button';
import { ConfirmDialog } from 'primereact/confirmdialog';
import { Dialog } from 'primereact/dialog';
import { Divider } from 'primereact/divider';
import { Image } from 'primereact/image';
import { InputText } from 'primereact/inputtext';
import { InputNumber} from 'primereact/inputnumber';
import { ProgressSpinner } from 'primereact/progressspinner';
import { TabMenu } from 'primereact/tabmenu';
import { Toast } from 'primereact/toast';
import { useFetchHome, useHome } from '../hooks';
import '../styles/home.css';

function Home({ children, publicPath }) {
  const {
    toast,
    changeAreaStatus,
    newAreaName,
    setNewAreaName,
    errorName,
    validateName,
    resetAreaName,
    deleteArea,
    resetAreaMaking,
    newAction,
    setNewAction,
    newReactions,
    areaToast,
    setActionArea,
    setReactionArea,
    cancelNewAction,
    cancelNewReaction,
    changeValueNewReaction,
    changeValueNewAction,
    saveNewArea,
  } = useHome();
  const {
    navigate,
    actionReac,
    setActionReac,
    panelActions,
    panelReactions,
    loading,
    tabAreas,
    setTabAreas,
    status,
    setStatus,
  } = useFetchHome();
  const actionReacOpts = [
    { label: 'Actions', disabled: status === 'GetReactions' || status === 'ConfigureReaction' },
    { label: 'Reactions', disabled: status === 'GetAction' || status === 'ConfigureAction' },
  ];
  const [areaTab, setAreaTab] = useState(0);
  const areaTabs = [
    { label: 'Favourite', icon: 'pi pi-star' },
    { label: 'All', icon: 'pi pi-list' },
  ];
  const [searchValue, setSearchValue] = useState('');
  const [confirmDelete, setConfirmDelete] = useState(false);

  if (loading) {
    return <ProgressSpinner />;
  }

  const renderItem = (item) => {
    if (!areaTab && !item.favorite) {
      return;
    }
    if (
      areaTab &&
      !item.name.toUpperCase().includes(searchValue.toUpperCase().trim().replace(/\s/g, ''))
    ) {
      return;
    }

    return (
      <div className='areaPreviewContainer' key={item.id}>
        <Button
          text
          raised
          rounded
          icon={item.favorite ? 'pi pi-star-fill' : 'pi pi-star'}
          onClick={(e) => {
            e.stopPropagation();
            changeAreaStatus(item, tabAreas, setTabAreas);
          }}
        />
        <div>{item.name}</div>
        <Button
          text
          raised
          rounded
          icon='pi pi-minus'
          onClick={(e) => {
            e.stopPropagation();
            deleteArea(item, tabAreas, setTabAreas);
          }}
        />
      </div>
    );
  };

  const footer = (
    <>
      <Button
        label='Cancel'
        onClick={() =>
          status === 'ConfigureAction' ? cancelNewAction(setStatus) : cancelNewReaction(setStatus)
        }
      />
      <Button
        label='Validate'
        onClick={() => {
          areaToast.current.show({ severity: 'success', summary: 'Successfully added ' + status === 'ConfigureAction' ? 'action' : 'reaction' });
          setStatus('GetReactions');
          setActionReac('Reactions');
        }}
      />
    </>
  );

  const footerAreaName = (
    <div>
      <Button label='Cancel' text onClick={() => resetAreaName(setStatus)} />
      <Button label='Validate' onClick={() => validateName(setStatus)} />
    </div>
  );

  return (
    <Background>
      <Dialog
        header='Enter the area name'
        visible={status === 'GetName'}
        onHide={() => resetAreaName(setStatus)}
        style={{ width: '20vw' }}
        footer={footerAreaName}>
        <InputText
          placeholder='Area Name'
          tooltip='Must be between 3 and 50 characters'
          className='searchContainer'
          value={newAreaName}
          onChange={(e) => setNewAreaName(e.target.value)}
        />
        {errorName ? <small className='p-error'>{errorName}</small> : null}
      </Dialog>
      <Dialog
        header={newAction.label}
        footer={footer}
        visible={status === 'ConfigureAction'}
        style={{ minWidth: '20vw' }}
        onHide={() => cancelNewAction(setStatus)}>
        <div className='dialog'>
          <InputNumber placeholder='Timer (in seconds)' value={newAction.timer} onChange={(e) => setNewAction(old => [{...old, timer: e.value}][0])} locale='fr-FR' suffix=' sec' min={1} />
          {newAction.defaultConfig
            ? Object.entries(newAction.defaultConfig).map((item, key) => (
                <InputText
                  key={key}
                  placeholder={item[0]}
                  value={item[1]}
                  onChange={(e) => changeValueNewAction(e, item[0])}
                />
              ))
            : null}
        </div>
      </Dialog>
      <Dialog
        header={newReactions[newReactions.length - 1]?.label}
        style={{ minWidth: '20vw' }}
        footer={footer}
        visible={status === 'ConfigureReaction'}
        onHide={() => cancelNewReaction(setStatus)}>
        <div className='dialog'>
          {newReactions[newReactions.length - 1]?.defaultConfig
            ? Object.entries(newReactions[newReactions.length - 1].defaultConfig).map(
                (item, key) => (
                  <InputText
                    placeholder={item[0]}
                    value={item[1]}
                    key={key}
                    onChange={(e) => changeValueNewReaction(e, item[0])}
                  />
                ),
              )
            : null}
        </div>
      </Dialog>
      <div className='toast'>
        <Toast ref={toast} position='top-center' />
      </div>
      <div className='areaToast'>
        <Toast ref={areaToast} />
      </div>
      <div className='globalGrid'>
        <div className='leftPannel'>
          <div className='titleContainer'>
            <Image src={publicPath + process.env.PUBLIC_URL + 'partial_icon.png'} width='150' />
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
          <div className='actionReacTab'>
            <TabMenu
              model={actionReacOpts}
              activeIndex={actionReac === 'Actions' ? 0 : 1}
              onTabChange={(e) => setActionReac(e.value.label)}
            />
          </div>
          <div className='panelContainer'>
            {actionReac === 'Actions' ? (
              <PanelAccordion
                baseList={panelActions}
                onClick={setActionArea}
                status={status}
                setStatus={setStatus}
              />
            ) : (
              <PanelAccordion
                baseList={panelReactions}
                onClick={setReactionArea}
                status={status}
                setStatus={setStatus}
              />
            )}
          </div>
        </div>
        <div className='areasContainer'>
          <div className='buttonAddArea'>
            <Button
              icon='pi pi-plus'
              iconPos='left'
              text
              raised
              rounded
              tooltip='Create new area'
              onClick={() => setStatus('GetName')}
            />
          </div>
          <ConfirmDialog
            visible={confirmDelete}
            onHide={() => setConfirmDelete(false)}
            header='Delete your Area ?'
            icon='pi pi-exclamation-triangle'
            message={"Are you sure you want to proceed ? You won't be able to go back"}
            accept={() => resetAreaMaking(setStatus)}
            reject={() => setConfirmDelete(false)}
          />
          {status !== 'Default' ? (
            <div className='buttonResetArea'>
              <Button
                icon='pi pi-trash'
                rounded
                raised
                text
                tooltip='Reset the creation'
                onClick={() => setConfirmDelete(true)}
              />
            </div>
          ) : null}
          {['GetReactions', 'ConfigureReaction'].indexOf(status) !== -1 && newReactions.length ? (
            <div className='buttonValidateArea'>
              <Button
                icon='pi pi-save'
                rounded
                raised
                text
                tooltip='Save the new Area'
                onClick={() => saveNewArea(setTabAreas, setStatus)}
              />
            </div>
          ) : null}
          <div className='newAreaName'>
            {status !== 'Default' ? 'Creating ' + newAreaName : null}
            <br />
            <br />
            {['Default', 'GetName'].indexOf(status) === -1 ? 'Areas:' : null}
            {status}
          </div>
        </div>
        <div className='rightPannel'>
          <div className='actionReacTab'>
            <TabMenu
              model={areaTabs}
              activeIndex={areaTab}
              onTabChange={(e) => setAreaTab(e.index)}
            />
          </div>
          {areaTab ? (
            <span className='p-input-icon-left' style={{ margin: '0 1vw 3vh 1vw' }}>
              <i className='pi pi-search' />
              <InputText
                className='searchContainer'
                placeholder='Search for areas..'
                value={searchValue}
                onChange={(e) => setSearchValue(e.target.value)}
              />
            </span>
          ) : null}
          <div className='areaDisplayContainer'>{tabAreas.map((item) => renderItem(item))}</div>
        </div>
        {children}
      </div>
    </Background>
  );
}

export default Home;
