import React from 'react';
import FormControlLabel from '@mui/material/FormControlLabel';
import { Switch } from '@mui/material';

export interface DryrunSwitchProps {
  dryrun: boolean;
  onChange: () => void;
}

function DryrunSwitch({ dryrun, onChange }: DryrunSwitchProps) {
  return (
    <FormControlLabel
      style={{ marginRight: '10px' }}
      labelPlacement='start'
      label={
        <div
          style={{
            fontSize: '14px',
            color: '#00000099',
          }}>
          {dryrun ? 'Dry Run' : 'Live'}
        </div>
      }
      control={<Switch onChange={onChange} />}
    />
  );
}

export default DryrunSwitch;
