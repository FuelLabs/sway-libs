import React from 'react';
import Button from '@mui/material/Button';
import PlayArrow from '@mui/icons-material/PlayArrow';
import DeleteForever from '@mui/icons-material/DeleteForever';
import IconButton from '@mui/material/IconButton';
import { FUEL_GREEN } from '../../../constants';
import Tooltip from '@mui/material/Tooltip';
import ConnectionButton from './ConnectionButton';
import { DeployState, NetworkState } from '../../../utils/types';

export interface ToolbarProps {
  onCompile: () => void;
  resetEditor: () => void;
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
}

function Toolbar({
  onCompile,
  resetEditor,
  networkState,
  setNetworkState,
  setDeployState,
  setNetwork,
}: ToolbarProps) {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'space-between',
        margin: '5px 0 15px',
      }}>
      <div>
        <Tooltip title='Compile sway code'>
          <Button
            style={{ color: 'black', background: FUEL_GREEN }}
            variant='contained'
            onClick={onCompile}
            endIcon={<PlayArrow />}>
            COMPILE
          </Button>
        </Tooltip>
        <ConnectionButton
          setDeployState={setDeployState}
          setNetwork={setNetwork}
          networkState={networkState}
          setNetworkState={setNetworkState}
        />
      </div>

      <Tooltip disableFocusListener title='Reset the editor'>
        <IconButton onClick={resetEditor} aria-label='reset the editor'>
          <DeleteForever />
        </IconButton>
      </Tooltip>
    </div>
  );
}

export default Toolbar;
