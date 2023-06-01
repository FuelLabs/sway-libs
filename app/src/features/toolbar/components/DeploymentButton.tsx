import React, { useCallback, useMemo } from 'react';
import { DeployState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import SecondaryButton from '../../../components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';
import { useProvider } from '../hooks/useProvider';
interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
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
  isCompiled,
  setContractId,
  deployState,
  setDeployState,
  setDrawerOpen,
  updateLog,
}: DeploymentButtonProps) {
  const { provider } = useProvider();

  const networkUrl = provider?.url;

  function handleError(error: Error) {
    setDeployState(DeployState.NOT_DEPLOYED);
    updateLog(`Deployment failed: ${error.message}`);
  }

  function handleSuccess(data: any) {
    setDeployState(DeployState.DEPLOYED);
    setContractId(data);
    setDrawerOpen(true);
    updateLog(`Contract deployed at address: ${data}`);
  }

  const { isDisabled, tooltip } = useMemo(() => {
    switch (deployState) {
      case DeployState.DEPLOYING:
        return {
          isDisabled: true,
          tooltip: `Deploying contract to ${networkUrl}`,
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
  }, [abi, bytecode, deployState, isCompiled, networkUrl]);

  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    handleError,
    handleSuccess,
    // Only enable the mutation after the deploy button is clicked. This prevents
    // the wallet from opening when the page first loads.
    isDisabled || deployState === DeployState.NOT_DEPLOYED
  );

  const onDeployClick = useCallback(async () => {
    updateLog(`Deploying contract to ${networkUrl}`);
    setDeployState(DeployState.DEPLOYING);
    deployContractMutation.mutate();
  }, [deployContractMutation, networkUrl, setDeployState, updateLog]);

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
