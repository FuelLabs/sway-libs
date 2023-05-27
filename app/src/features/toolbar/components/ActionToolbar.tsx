import React from 'react';
import PlayArrow from '@mui/icons-material/PlayArrow';
import { DeployState, NetworkState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';

export interface ToolbarProps {
  deployState: DeployState;
  contractId: string;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiled: boolean;
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
