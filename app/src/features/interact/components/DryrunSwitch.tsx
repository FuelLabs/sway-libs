import React from "react";
import FormControlLabel from "@mui/material/FormControlLabel";
import Switch from "@mui/material/Switch";

export interface DryrunSwitchProps {
  dryrun: boolean;
  onChange: () => void;
}

function DryrunSwitch({ dryrun, onChange }: DryrunSwitchProps) {
  return (
    <FormControlLabel
      style={{ marginRight: "10px" }}
      labelPlacement="start"
      label={
        <div
          style={{
            fontSize: "12px",
            color: "#00000099",
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
