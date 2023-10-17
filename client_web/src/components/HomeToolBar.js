import { Button, TextField } from '@mui/material';
import SaveIcon from '@mui/icons-material/Save';
import AddIcon from '@mui/icons-material/Add';
import { useState } from 'react';

const HomeToolbar = ({
  saveBoolean,
  addNameToBlankArea,
  addCreatedAreaToAreas,
  onClickForCreateArea,
  onEnterNameArea,
}) => {
  const [isAddClicked, setIsAddClicked] = useState(false);
  const [isNextStep, setisNextStep] = useState(true);

  const addClick = () => {
    onClickForCreateArea();
    if (isNextStep === false) setisNextStep(true);
    if (isAddClicked === true) setIsAddClicked(false);
    else setIsAddClicked(true);
  };

  return (
    <div
      style={{
        height: '10%',
        width: '100%',
        backgroundColor: 'rgba(255, 250, 251, 0.1)',
        display: 'flex',
        alignItems: 'center',
      }}>
      <div style={{ flex: 1 }}></div>
      <div>
        <TextField
          placeholder='Area Name'
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              setisNextStep(false);
              onEnterNameArea();
            }
          }}
          onChange={(e) => {
            addNameToBlankArea({ name: e.target.value });
          }}
          sx={{ input: { color: 'white' }, borderColor: 'white' }}
          disabled={!isAddClicked || !isNextStep}
          style={
            !isAddClicked || !isNextStep
              ? { backgroundColor: 'rgba(255, 250, 251, 0.2)', borderRadius: '5px', color: 'black' }
              : {}
          }
        />
      </div>
      <div
        style={{
          flex: 1,
          display: 'flex',
          justifyContent: 'flex-end',
          marginRight: '2%',
        }}>
        <Button
          variant='contained'
          color='primary'
          style={{ marginRight: '1rem' }}
          endIcon={<SaveIcon />}
          disabled={!saveBoolean}
          onClick={addCreatedAreaToAreas}>
          Save Area
        </Button>
        <Button
          variant='outlined'
          color='secondary'
          style={{
            backgroundColor: '#1B1A2A',
            color: 'white',
            borderColor: 'white',
          }}
          onClick={addClick}
          endIcon={<AddIcon />}>
          New Area
        </Button>
      </div>
    </div>
  );
};

export default HomeToolbar;
