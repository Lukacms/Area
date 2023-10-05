import AreaCard from "../components/AreaCard";
import {
  Button,
  ToggleButton,
  ToggleButtonGroup,
  IconButton,
  TextField,
  AppBar,
  Stack,
} from "@mui/material";
import HomeToolbar from "../components/HomeToolBar";
import { useEffect, useState } from "react";

const AreaBuild = ({
  canSave,
  selectedArea,
  addNameToBlankArea,
  addCreatedAreaToAreas,
  onClickForCreateArea,
  onEnterNameArea,
  currentState,
}) => {
  return (
    <Stack>
      <HomeToolbar
        saveBoolean={canSave}
        addNameToBlankArea={addNameToBlankArea}
        addCreatedAreaToAreas={addCreatedAreaToAreas}
        onClickForCreateArea={onClickForCreateArea}
        onEnterNameArea={onEnterNameArea}
      />
      <div className="middleDiv" style={{ flex: 2 }}>
        <p> {currentState} </p>
        <AreaCard area={selectedArea} />
      </div>
    </Stack>
  );
};

export default AreaBuild;
