import React from 'react';
import FormControlLabel from '@mui/material/FormControlLabel';
import Switch from '@mui/material/Switch';
import { lightColors } from '@fuel-ui/css';
import { useThemeContext } from '../../../context/theme';

export interface DryrunSwitchProps {
  dryrun: boolean;
  onChange: () => void;
}

function DryrunSwitch({ dryrun, onChange }: DryrunSwitchProps) {
  // Import theme state
  const theme = useThemeContext().theme;

  return (
    <FormControlLabel
      style={{ marginRight: '10px' }}
      labelPlacement='start'
      label={
        <div
          style={{
            fontSize: '12px',
            color: theme === 'light' ? '#00000099' : lightColors.scalesGreen7,
          }}>
          {dryrun ? 'DRY RUN' : 'LIVE'}
        </div>
      }
      control={<Switch onChange={onChange} style={{color: theme === 'light' ? '' : lightColors.scalesGreen7,}}/>}
    />
  );
}

export default DryrunSwitch;
