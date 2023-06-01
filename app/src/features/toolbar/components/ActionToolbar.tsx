import React from 'react';
import PlayArrow from '@mui/icons-material/PlayArrow';
import { DeployState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';
import { useFuel } from '../hooks/useFuel';

export interface ActionToolbarProps {
  deployState: DeployState;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiled: boolean;
  setDeployState: (state: DeployState) => void;
  drawerOpen: boolean;
  setDrawerOpen: (open: boolean) => void;
  updateLog: (entry: string) => void;
}

function ActionToolbar({
  deployState,
  setContractId,
  onCompile,
  isCompiled,
  setDeployState,
  drawerOpen,
  setDrawerOpen,
  updateLog,
}: ActionToolbarProps) {
  const { fuel, isLoading } = useFuel();

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
      {!fuel && !isLoading ? (
        <SecondaryButton
          style={{ minWidth: '115px', marginLeft: '15px' }}
          onClick={() =>
            window.open('https://wallet.fuel.network/docs/install/', '_blank')
          }
          text='INSTALL'
          tooltip={'Install the fuel wallet to deploy contracts'}
        />
      ) : (
        <DeploymentButton
          abi={loadAbi()}
          bytecode={loadBytecode()}
          isCompiled={isCompiled}
          setContractId={setContractId}
          deployState={deployState}
          setDeployState={setDeployState}
          setDrawerOpen={setDrawerOpen}
          updateLog={updateLog}
        />
      )}
      <SecondaryButton
        style={{ minWidth: '115px', marginLeft: '15px' }}
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
