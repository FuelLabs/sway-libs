import React from 'react';
import PlayArrow from '@mui/icons-material/PlayArrow';
import OpenInNew from '@mui/icons-material/OpenInNew';
import { DeployState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';
import { useFuel } from '@fuel-wallet/react';
import {
  loadAbi,
  loadBytecode,
  loadStorageSlots,
} from '../../../utils/localStorage';

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
  let { fuel } = useFuel();
  const fuelInstalled = !!fuel.currentConnector();

  return (
    <div
      style={{
        margin: '5px 0 15px',
        display: 'flex',
      }}>
      <CompileButton
        onClick={onCompile}
        text='COMPILE'
        endIcon={<PlayArrow style={{ fontSize: '18px' }} />}
        disabled={isCompiled === true || deployState === DeployState.DEPLOYING}
        tooltip='Compile sway code'
      />
      {!fuelInstalled ? (
        <SecondaryButton
          header={true}
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
          storageSlots={loadStorageSlots()}
          isCompiled={isCompiled}
          setContractId={setContractId}
          deployState={deployState}
          setDeployState={setDeployState}
          setDrawerOpen={setDrawerOpen}
          updateLog={updateLog}
        />
      )}
      <SecondaryButton
        header={true}
        onClick={() => setDrawerOpen(!drawerOpen)}
        text='INTERACT'
        disabled={deployState !== DeployState.DEPLOYED}
        tooltip={
          deployState !== DeployState.DEPLOYED
            ? 'A contract must be deployed to interact with it on-chain'
            : 'Interact with the contract ABI'
        }
      />
      <SecondaryButton
        header={true}
        onClick={() =>
          window.open(
            'https://docs.fuel.network/docs/sway',
            '_blank',
            'noreferrer'
          )
        }
        text='DOCS'
        tooltip={'Open documentation for Sway in a new tab'}
        endIcon={<OpenInNew style={{ fontSize: '16px' }} />}
      />
    </div>
  );
}

export default ActionToolbar;
