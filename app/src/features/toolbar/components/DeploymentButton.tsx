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
import { useCallback, useMemo } from 'react';
import ConnectionButton from './ConnectionButton';
import { useFuel } from '../hooks/useFuel';

interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  contractId: string;
  isCompiled: boolean;
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
  isCompiled,
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

  const { isDisabled, tooltip } = useMemo(() => {
    switch (deployState) {
      case DeployState.DEPLOYING:
        return {
          isDisabled: true,
          tooltip: 'Deploying the contract',
        };
      case DeployState.NOT_DEPLOYED:
        return {
          isDisabled: !abi || !bytecode || !isCompiled,
          tooltip: 'Deploy a contract to interact with it on-chain',
        };
      case DeployState.DEPLOYED:
        return {
          isDisabled: false,
          tooltip:
            'Contract is deployed. You can interact with the deployed contract or re-compile and deploy a new contract.',
        };
    }
  }, [abi, bytecode, deployState, isCompiled]);

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
      disabled={isDisabled}
      endIcon={
        deployState === DeployState.DEPLOYING ? <ButtonSpinner /> : undefined
      }
      tooltip={tooltip}
    />
  );
}
