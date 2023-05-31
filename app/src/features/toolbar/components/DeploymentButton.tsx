import React from 'react';
import { DeployState, NetworkState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import SecondaryButton from '../../../components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';
import { useCallback, useMemo } from 'react';
import ConnectionButton from './ConnectionButton';
interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  isCompiled: boolean;
  setContractId: (contractId: string) => void;
  deployState: DeployState;
  setDeployState: (state: DeployState) => void;
  networkState: NetworkState;
  setNetworkState: (state: NetworkState) => void;
  setDrawerOpen: (open: boolean) => void;
  setError: (error: string) => void;
}

export function DeploymentButton({
  abi,
  bytecode,
  isCompiled,
  setContractId,
  deployState,
  setDeployState,
  networkState,
  setNetworkState,
  setDrawerOpen,
  setError,
}: DeploymentButtonProps) {
  function handleError(error: Error) {
    setDeployState(DeployState.NOT_DEPLOYED);
    setError(`Deployment failed: ${error.message}`);
  }

  function handleSuccess(data: any) {
    setDeployState(DeployState.DEPLOYED);
    setContractId(data);
    setDrawerOpen(true);
  }

  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    handleError,
    handleSuccess
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
        networkState={networkState}
        setNetworkState={setNetworkState}
        setError={setError}
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
