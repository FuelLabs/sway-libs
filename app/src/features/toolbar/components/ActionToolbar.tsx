import React from 'react';
import PlayArrow from '@mui/icons-material/PlayArrow';
import { DeployState, NetworkState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';

export interface ActionToolbarProps {
  deployState: DeployState;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiled: boolean;
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDeployState: (state: DeployState) => void;
  drawerOpen: boolean;
  setDrawerOpen: (open: boolean) => void;
  setError: (error: string) => void;
}

function ActionToolbar({
  deployState,
  setContractId,
  onCompile,
  isCompiled,
  networkState,
  setNetworkState,
  setDeployState,
  drawerOpen,
  setDrawerOpen,
  setError,
}: ActionToolbarProps) {
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
        isCompiled={isCompiled}
        setContractId={setContractId}
        deployState={deployState}
        setDeployState={setDeployState}
        networkState={networkState}
        setNetworkState={setNetworkState}
        setDrawerOpen={setDrawerOpen}
        setError={setError}
      />
      <SecondaryButton
        style={{ marginLeft: '15px' }}
        onClick={() => setDrawerOpen(!drawerOpen)}
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

export default ActionToolbar;
