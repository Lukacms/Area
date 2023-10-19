import { useState } from 'react';
import { Background, PanelAccordion } from '../components';
import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { Divider } from 'primereact/divider';
import { Image } from 'primereact/image';
import { InputText } from 'primereact/inputtext';
import { PanelMenu } from 'primereact/panelmenu';
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
    newReactions,
    areaToast,
    setActionArea,
    setReactionArea,
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
        header={newAction.name}
        visible={status === 'ConfigureAction'}
        onHide={() => setStatus('GetAction')}></Dialog>
      <Dialog
        header={newReactions[newReactions?.length - 1]?.name}
        visible={status === 'ConfigureReaction'} onHide={() => setStatus('GetReactions')}></Dialog>
      <Dialog visible={status === 'ConfigureAction'} onHide={() => setStatus('GetAction')} />
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
              <PanelAccordion baseList={panelActions} onClick={setActionArea} status={status} setStatus={setStatus} />
            ) : (
              <PanelAccordion baseList={panelReactions} onClick={setReactionArea} status={status} setStatus={setStatus} />
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
