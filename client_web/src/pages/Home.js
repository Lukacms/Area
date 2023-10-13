import '../styles/home.css';
import { PanelMenu } from 'primereact/panelmenu';
import { Divider } from 'primereact/divider';
import { useNavigate } from 'react-router-dom';
import { AreaBuild } from '../components';
import { useHome } from '../hooks';
import { styled } from '@mui/material/styles';
import { ToggleButton, ToggleButtonGroup, IconButton, TextField } from '@mui/material';
import MoreHorizIcon from '@mui/icons-material/MoreHoriz';
import InputAdornment from '@mui/material/InputAdornment';
import SearchIcon from '@mui/icons-material/Search';
import { useState } from 'react';
import React from 'react';

const Home = ({children}) => {
  const {
    dispAct,
    dispReac,
    actionOrReaction,
    panelAreas,
    selectedArea,
    addNameToBlankArea,
    addCreatedAreaToAreas,
    currentState,
    currentSelectedCategory,
    onClickForCreateArea,
    updateCurrentSelectedCategory,
    onEnterNameArea,
    canSave,
  } = useHome();

  const navigate = useNavigate();

  const [displayedCategory, setDisplayedCategory] = useState('actions');

  const handleChange = (event, newSelectedValue) => {
    setDisplayedCategory(newSelectedValue);
    updateCurrentSelectedCategory(newSelectedValue);
    if (newSelectedValue === 'actions') {
      dispAct();
    } else {
      dispReac();
    }
  };
  if (currentSelectedCategory !== displayedCategory) {
    handleChange(null, currentSelectedCategory);
  }
  return (
    <div className='globalDiv'>
      <div className='leftDiv'>
        <div className='topLeft'>
          <b className='fastrText' style={{ paddingLeft: '5%' }}>
            FastR
          </b>
          <IconButton
            label='setting'
            style={{ border: '1%', color: 'white', borderRadius: '50%' }}
            onClick={() => navigate('/settings')}>
            <MoreHorizIcon style={{ color: 'white' }} />
          </IconButton>
        </div>
        <div className='selectButton'>
          <StyledToggleButtonGroup
            exclusive
            value={displayedCategory}
            onChange={handleChange}
            aria-label='categories'
            style={{
              width: '100%',
              backgroundColor: 'rgba(255, 250, 251, 0.1)',
              borderRadius: '10px',
            }}>
            <ToggleButton
              value='actions'
              style={{ color: 'white', width: '50%' }}
              aria-label='category'>
              Actions
            </ToggleButton>
            <ToggleButton
              value='reactions'
              style={{ color: 'white', width: '50%' }}
              aria-label='category'>
              Reactions
            </ToggleButton>
          </StyledToggleButtonGroup>
        </div>
        <Divider />
        <b style={{ alignSelf: 'center', marginBottom: '5%' }}>
          {currentSelectedCategory.toUpperCase()}
        </b>
        <PanelMenu
          model={actionOrReaction}
          className='pannelMenu'
          style={{ backgroundColor: 'transparent' }}
        />
      </div>
      <AreaBuild
        canSave={canSave}
        selectedArea={selectedArea}
        currentState={currentState}
        addNameToBlankArea={addNameToBlankArea}
        addCreatedAreaToAreas={addCreatedAreaToAreas}
        onClickForCreateArea={onClickForCreateArea}
        onEnterNameArea={onEnterNameArea}
      />
      <div
        className='rightDiv'
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
        }}>
        <b style={{ marginTop: '10%', fontSize: 25 }}>Areas</b>
        <TextField
          id='input-with-icon-textfield'
          InputProps={{
            startAdornment: (
              <InputAdornment position='start'>
                <SearchIcon
                  style={{
                    color: 'rgba(255, 250, 251, 0.5)',
                    marginLeft: '10%',
                  }}
                />
                <b
                  style={{
                    color: 'rgba(255, 250, 251, 0.5)',
                  }}>
                  Rechercher
                </b>
              </InputAdornment>
            ),
          }}
          variant='standard'
        />
        <PanelMenu
          model={panelAreas}
          className='pannelMenu'
          style={{
            backgroundColor: 'transparent',
            marginTop: '10%',
            width: '100%',
          }}
          p-menuitem-icon='pi pi-folder'
        />
      {children}
      </div>
    </div>
  );
};

export default Home;

const StyledToggleButtonGroup = styled(ToggleButtonGroup)(({ theme }) => ({
  '& .MuiToggleButtonGroup-grouped': {
    margin: theme.spacing(0.5),
    color: 'white',
    border: 0,
    '&.Mui-disabled': {
      border: 0,
    },
    '&:not(:first-of-type)': {
      borderRadius: theme.shape.borderRadius,
    },
    '&:first-of-type': {
      borderRadius: theme.shape.borderRadius,
    },
  },
}));
