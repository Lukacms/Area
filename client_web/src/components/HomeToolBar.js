import {
  Button,
  ToggleButton,
  ToggleButtonGroup,
  IconButton,
  TextField,
  AppBar,
  Stack,
} from "@mui/material";
import SaveIcon from "@mui/icons-material/Save";
import AddIcon from "@mui/icons-material/Add";


const HomeToolbar = ({saveBoolean}) => {
  return (
    <div
      style={{
        height: "10%",
        width: "100%",
        backgroundColor: "rgba(255, 250, 251, 0.1)",
        display: "flex",
        alignItems: "center",
      }}
    >
      <div style={{ flex: 1 }}></div>
      <div>
        <TextField
          placeholder="Area Name"
          sx={{ input: { color: "white" }, borderColor: "white" }}
        />
      </div>
      <div
        style={{
          flex: 1,
          display: "flex",
          justifyContent: "flex-end",
          marginRight: "2%",
        }}
      >
        <Button
          variant="contained"
          color="primary"
          style={{ marginRight: "1rem" }}
          endIcon={<SaveIcon />}
          disabled={!saveBoolean}
        >
          Save Area
        </Button>
        <Button
          variant="outlined"
          color="secondary"
          style={{
            backgroundColor: "#1B1A2A",
            color: "white",
            borderColor: "white",
          }}
          endIcon={<AddIcon />}
        >
          New Area
        </Button>
      </div>
    </div>
  );
};

export default HomeToolbar;
