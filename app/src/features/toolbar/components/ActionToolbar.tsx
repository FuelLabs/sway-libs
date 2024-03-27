import React, { useCallback } from 'react';
import PlayArrow from '@mui/icons-material/PlayArrow';
import OpenInNew from '@mui/icons-material/OpenInNew';
import { DeployState } from '../../../utils/types';
import { DeploymentButton } from './DeploymentButton';
import CompileButton from './CompileButton';
import SecondaryButton from '../../../components/SecondaryButton';
import {
  loadAbi,
  loadBytecode,
  loadStorageSlots,
} from '../../../utils/localStorage';
import { useIsMobile } from '../../../hooks/useIsMobile';

export interface ActionToolbarProps {
  deployState: DeployState;
  setContractId: (contractId: string) => void;
  onCompile: () => void;
  isCompiled: boolean;
  setDeployState: (state: DeployState) => void;
  drawerOpen: boolean;
  setDrawerOpen: (open: boolean) => void;
  showSolidity: boolean;
  setShowSolidity: (open: boolean) => void;
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
  showSolidity,
  setShowSolidity,
  updateLog,
}: ActionToolbarProps) {
  const isMobile = useIsMobile();
  const onDocsClick = useCallback(() => {
    window.open('https://docs.fuel.network/docs/sway', '_blank', 'noreferrer');
  }, []);

  return (
    <div
      style={{
        margin: '5px 0 10px',
        display: isMobile ? 'inline-table' : 'flex',
      }}>
      <CompileButton
        onClick={onCompile}
        text='COMPILE'
        endIcon={<PlayArrow style={{ fontSize: '18px' }} />}
        disabled={isCompiled === true || deployState === DeployState.DEPLOYING}
        tooltip='Compile sway code'
      />
      {!isMobile && (
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
      {!isMobile && deployState === DeployState.DEPLOYED && (
        <SecondaryButton
          header={true}
          onClick={() => setDrawerOpen(!drawerOpen)}
          text='INTERACT'
          tooltip={
            deployState !== DeployState.DEPLOYED
              ? 'A contract must be deployed to interact with it on-chain'
              : 'Interact with the contract ABI'
          }
        />
      )}
      <SecondaryButton
        header={true}
        onClick={() => setShowSolidity(!showSolidity)}
        text='SOLIDITY'
        tooltip={
          showSolidity
            ? 'Hide the Solidity editor'
            : 'Show the Solidity editor to transpile Solidity to Sway'
        }
      />
      <SecondaryButton
        header={true}
        onClick={onDocsClick}
        text='DOCS'
        tooltip={'Open documentation for Sway in a new tab'}
        endIcon={<OpenInNew style={{ fontSize: '16px' }} />}
      />
    </div>
  );
}

export default ActionToolbar;
