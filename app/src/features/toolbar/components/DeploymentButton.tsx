import Button from '@mui/material/Button';
import { DeployState, NetworkState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import { colorKeys, darkColors } from '@fuel-ui/css';
import { lightColors } from '@fuel-ui/css';
import { Spinner } from '@fuel-ui/react';
import Tooltip from '@mui/material/Tooltip';
import SecondaryButton from '../../../components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';
import { useConnection } from '../hooks/useConnection';
import { useCallback } from 'react';
import ConnectionButton from './ConnectionButton';

interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  contractId: string;
  setContractId: (contractId: string) => void;
  deployState: DeployState;
  setDeployState: (state: DeployState) => void;
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setNetwork: (network: string) => void;
}

export function DeploymentButton({
  abi,
  bytecode,
  contractId,
  setContractId,
  deployState,
  setDeployState,
  networkState,
  setNetworkState,
  setNetwork,
}: DeploymentButtonProps) {
  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    setContractId,
    setDeployState
  );

  const onDeployClick = useCallback(() => {
    if (networkState === NetworkState.CAN_DISCONNECT) {
      setDeployState(DeployState.DEPLOYING);
      deployContractMutation.mutate();
    }
  }, [deployContractMutation, networkState, setDeployState]);

  if (networkState === NetworkState.CAN_CONNECT) {
    return (
      <ConnectionButton
        setDeployState={setDeployState}
        setNetwork={setNetwork}
        networkState={networkState}
        setNetworkState={setNetworkState}
      />
    );
  }

  return (
    <SecondaryButton
      style={{ minWidth: '115px', marginLeft: '15px' }}
      onClick={onDeployClick}
      text='DEPLOY'
      disabled={!abi || !bytecode || deployState === DeployState.DEPLOYING}
      endIcon={
        deployState === DeployState.DEPLOYING ? <ButtonSpinner /> : undefined
      }
      tooltip={
        deployState === DeployState.NOT_DEPLOYED
          ? 'Deploy a contract to interact with it on-chain'
          : deployState === DeployState.DEPLOYING
          ? 'Deploying contract'
          : 'Deploy contract'
      }
    />
  );
}
