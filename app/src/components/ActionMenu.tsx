import React from 'react';
import Button from '@mui/material/Button';
import PlayArrow from '@mui/icons-material/PlayArrow';
import DeleteForever from '@mui/icons-material/DeleteForever';
import IconButton from '@mui/material/IconButton';
import { FUEL_GREEN } from '../constants';
import Tooltip from '@mui/material/Tooltip';

export interface ActionMenuProps {
  onCompile: () => void;
  resetEditor: () => void;
}

function ActionMenu({ onCompile, resetEditor }: ActionMenuProps) {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'space-between',
        margin: '0 0 15px',
      }}>
      <Tooltip disableFocusListener title='Compile sway code'>
        <Button
          style={{ color: '#000000DE', background: FUEL_GREEN }}
          variant='contained'
          onClick={onCompile}
          endIcon={<PlayArrow />}>
          COMPILE
        </Button>
      </Tooltip>

      <Tooltip disableFocusListener title='Reset the editor'>
        <IconButton onClick={resetEditor} aria-label='reset the editor'>
          <DeleteForever />
        </IconButton>
      </Tooltip>
    </div>
  );
}

export default ActionMenu;
