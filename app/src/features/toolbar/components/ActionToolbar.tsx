import React, { useState } from 'react';
import Button from '@mui/material/Button';
import PlayArrow from '@mui/icons-material/PlayArrow';
import DeleteForever from '@mui/icons-material/DeleteForever';
import IconButton from '@mui/material/IconButton';
import { FUEL_GREEN } from '../../../constants';
import Tooltip from '@mui/material/Tooltip';
import ConnectionButton from './ConnectionButton';
import { DeployState, NetworkState } from '../../../utils/types';
import { DeploymentButton } from '../../deploy/components/DeploymentButton';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { darkColors, lightColors } from '@fuel-ui/css';
import ButtonGroup from '@mui/material/ButtonGroup';
import styled from '@emotion/styled';
import CompileButton from './CompileButton';
import SecondaryButton from './SecondaryButton';
import { Spinner } from '@fuel-ui/react';
import { ButtonSpinner } from '../../../components/shared';

export interface ToolbarProps {
  deployState: DeployState;
  contractId: string;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiling: boolean;
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
  isCompiling,
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
        endIcon={isCompiling ? <ButtonSpinner /> : <PlayArrow />}
        disabled={deployState === DeployState.DEPLOYING}
        tooltip='Compile sway code'
      />
      <DeploymentButton
        abi={loadAbi()}
        bytecode={loadBytecode()}
        contractId={contractId}
        setContractId={setContractId}
        deployState={deployState}
        setDeployState={setDeployState}
      />
      <SecondaryButton
        style={{ marginLeft: '15px' }}
        onClick={toggleDrawer}
        text='INTERACT'
        disabled={deployState !== DeployState.DEPLOYED}
        tooltip={
          deployState !== DeployState.DEPLOYED
            ? 'Contract must be deployed to interact with it on-chain'
            : 'Interact with the contract'
        }
      />
    </div>
  );
}

export default Toolbar;
