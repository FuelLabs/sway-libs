import React from "react";
import FormControlLabel from "@mui/material/FormControlLabel";
import Switch from "@mui/material/Switch";
import useTheme from "../../../context/theme";

export interface DryrunSwitchProps {
  dryrun: boolean;
  onChange: () => void;
}

function DryrunSwitch({ dryrun, onChange }: DryrunSwitchProps) {
  const { themeColor } = useTheme();

  return (
    <FormControlLabel
      sx={{
        color: themeColor("white3"),
        marginRight: "10px",
        ".MuiSwitch-track": {
          background: themeColor("gray2"),
        },
      }}
      labelPlacement="start"
      label={
        <div
          style={{
            fontSize: "12px",
          }}
        >
          {dryrun ? "DRY RUN" : "LIVE"}
        </div>
      }
      control={<Switch onChange={onChange} />}
    />
  );
}

export default DryrunSwitch;
