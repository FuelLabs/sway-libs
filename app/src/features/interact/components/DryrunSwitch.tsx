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
        marginRight: "10px",
      }}
      labelPlacement="start"
      label={
        <div
          style={{
            fontSize: "12px",
            color: themeColor("gray1"),
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
