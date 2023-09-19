import React, { useCallback, useMemo } from 'react';
import { DeployState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import SecondaryButton from '../../../components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';
import { useProvider } from '@fuel-wallet/react';

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
  const { provider } = useProvider();

  const networkUrl = provider?.url;

  const handleError = useCallback(
    (error: Error) => {
      setDeployState(DeployState.NOT_DEPLOYED);
      updateLog(`Deployment failed: ${error.message}`);
    },
    [setDeployState, updateLog]
  );

  const handleSuccess = useCallback(
    (data: any) => {
      setDeployState(DeployState.DEPLOYED);
      setContractId(data);
      setDrawerOpen(true);
      updateLog(`Contract was successfully deployed to ${networkUrl}`);
    },
    [setContractId, setDeployState, setDrawerOpen, updateLog, networkUrl]
  );

  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    storageSlots,
    handleError,
    handleSuccess,
    updateLog,
    // Only attempt to fetch the wallet after the deploy button has been clicked. This prevents
    // the wallet from opening when the page first loads.
    deployState === DeployState.NOT_DEPLOYED
  );

  const onDeployClick = useCallback(async () => {
    updateLog(`Deploying contract...`);
    setDeployState(DeployState.DEPLOYING);
    deployContractMutation.mutate();
  }, [deployContractMutation, setDeployState, updateLog]);

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
