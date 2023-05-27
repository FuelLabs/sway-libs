import React, { useState } from 'react';
import Button from '@mui/material/Button';
import PlayArrow from '@mui/icons-material/PlayArrow';
import DeleteForever from '@mui/icons-material/DeleteForever';
import IconButton from '@mui/material/IconButton';
import { FUEL_GREEN } from '../../../constants';
import Tooltip from '@mui/material/Tooltip';
import ConnectionButton from './ConnectionButton';
import { DeployState, NetworkState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { darkColors, lightColors } from '@fuel-ui/css';
import ButtonGroup from '@mui/material/ButtonGroup';
import styled from '@emotion/styled';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';
import { Spinner } from '@fuel-ui/react';
import { ButtonSpinner } from '../../../components/shared';
import PlayCircleFilledWhiteOutlinedIcon from '@mui/icons-material/PlayCircleFilledWhiteOutlined';
import PlayArrowOutlinedIcon from '@mui/icons-material/PlayArrowOutlined';
import PlayCircleFilledOutlinedIcon from '@mui/icons-material/PlayCircleFilledOutlined';

export interface ToolbarProps {
  deployState: DeployState;
  contractId: string;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiled: boolean;
  // resetEditor: () => void;
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
  toggleDrawer: () => void;
}

function Toolbar({
  deployState,
  contractId,
  setContractId,
  onCompile,
  isCompiled,
  // resetEditor,
  networkState,
  setNetworkState,
  setDeployState,
  setNetwork,
  toggleDrawer,
}: ToolbarProps) {
  return (
    <div
      style={{
        margin: '5px 0 15px',
        display: 'flex',
      }}>
      <CompileButton
        onClick={onCompile}
        text='COMPILE'
        endIcon={<PlayArrow />}
        disabled={isCompiled === true || deployState === DeployState.DEPLOYING}
        tooltip='Compile sway code'
      />
      <DeploymentButton
        abi={loadAbi()}
        bytecode={loadBytecode()}
        contractId={contractId}
        isCompiled={isCompiled}
        setContractId={setContractId}
        deployState={deployState}
        setDeployState={setDeployState}
        networkState={networkState}
        setNetworkState={setNetworkState}
        setNetwork={setNetwork}
      />
      <SecondaryButton
        style={{ marginLeft: '15px' }}
        onClick={toggleDrawer}
        text='INTERACT'
        disabled={deployState !== DeployState.DEPLOYED}
        tooltip={
          deployState !== DeployState.DEPLOYED
            ? 'A contract must be deployed to interact with it on-chain'
            : 'Interact with the contract ABI'
        }
      />
    </div>
  );
}

export default Toolbar;
