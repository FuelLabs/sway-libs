import React, { useCallback, useMemo } from 'react';
import { DeployState } from '../../../utils/types';
import {
  DeployContractData,
  useDeployContract,
} from '../hooks/useDeployContract';
import SecondaryButton from '../../../components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';
import { useFuel } from '@fuel-wallet/react';

interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  storageSlots: string;
  isCompiled: boolean;
  setContractId: (contractId: string) => void;
  deployState: DeployState;
  setDeployState: (state: DeployState) => void;
  setDrawerOpen: (open: boolean) => void;
  updateLog: (entry: string) => void;
}

export function DeploymentButton({
  abi,
  bytecode,
  storageSlots,
  isCompiled,
  setContractId,
  deployState,
  setDeployState,
  setDrawerOpen,
  updateLog,
}: DeploymentButtonProps) {
  const { fuel } = useFuel();

  const handleError = useCallback(
    (error: Error) => {
      setDeployState(DeployState.NOT_DEPLOYED);
      updateLog(`Deployment failed: ${error.message}`);
    },
    [setDeployState, updateLog]
  );

  const handleSuccess = useCallback(
    ({ contractId, networkUrl }: DeployContractData) => {
      setDeployState(DeployState.DEPLOYED);
      setContractId(contractId);
      setDrawerOpen(true);
      updateLog(`Contract was successfully deployed to ${networkUrl}`);
    },
    [setContractId, setDeployState, setDrawerOpen, updateLog]
  );

  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    storageSlots,
    handleError,
    handleSuccess,
    updateLog
  );

  const onDeployClick = useCallback(async () => {
    const isConnected = await fuel.currentConnector()?.connect();
    if (isConnected) {
      updateLog(`Deploying contract...`);
      setDeployState(DeployState.DEPLOYING);
      deployContractMutation.mutate();
    } else {
      handleError(new Error('Failed to connect to wallet.'));
    }
  }, [deployContractMutation, setDeployState, updateLog, fuel, handleError]);

  const { isDisabled, tooltip } = useMemo(() => {
    switch (deployState) {
      case DeployState.DEPLOYING:
        return {
          isDisabled: true,
          tooltip: `Deploying contract`,
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

  return (
    <SecondaryButton
      header={true}
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
