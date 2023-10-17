import { useState } from 'react';
import { Image } from 'primereact/image';
import { Button } from 'primereact/button';
import { Divider } from 'primereact/divider';
import { TabMenu } from 'primereact/tabmenu';
import { PanelMenu } from 'primereact/panelmenu';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Background } from '../components';
import { useFetchHome, useHome } from '../hooks';
import '../styles/home.css';
import { Toast } from 'primereact/toast';
import { InputText } from 'primereact/inputtext';

function Home({ children, publicPath }) {
  const {
    navigate,
    actionReac,
    setActionReac,
    panelActions,
    panelReactions,
    loading,
    tabAreas,
    setTabAreas,
  } = useFetchHome();
  const { toast, changeAreaStatus } = useHome();
  const actionReacOpts = [{ label: 'Actions' }, { label: 'Reactions' }];
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
      <div className='areaPreviewContainer'>
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
        <Button text raised rounded icon='pi pi-minus' />
      </div>
    );
  };

  return (
    <Background>
      <div className='toast'>
        <Toast ref={toast} position='top-center' />
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
              activeIndex={actionReac == 'Actions' ? 0 : 1}
              onTabChange={(e) => setActionReac(e.value.label)}
            />
          </div>
          <div className='panelContainer'>
            {actionReac === 'Actions' ? (
              <PanelMenu model={panelActions} />
            ) : (
              <PanelMenu model={panelReactions} />
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
            />
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
