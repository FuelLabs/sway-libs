import { Button, Copyable, Text } from '@fuel-ui/react';
import { cssObj } from '@fuel-ui/css';
import { DeployState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';

interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  contractId: string;
  setContractId: (contractId: string) => void;
  deployState: DeployState;
  setDeployState: (state: DeployState) => void;
}

export function DeploymentButton({
  abi,
  bytecode,
  contractId,
  setContractId,
  deployState,
  setDeployState,
}: DeploymentButtonProps) {
  const deployContractMutation = useDeployContract(
    abi,
    bytecode,
    setContractId,
    setDeployState
  );

  function onDeployClick() {
    setDeployState(DeployState.DEPLOYING);
    deployContractMutation.mutate();
  }

  return (
    <>
      {deployState === DeployState.NOT_DEPLOYED ? (
        <>
          <Button
            onPress={onDeployClick}
            type='button'
            color='accent'
            isDisabled={!abi || !bytecode}>
            DEPLOY
          </Button>
        </>
      ) : deployState === DeployState.DEPLOYING ? (
        <Button type='button' color='gray' isDisabled>
          {' '}
          DEPLOYING...
        </Button>
      ) : (
        <>
          {/* <Copyable value={contractId} css={styles.contractAddress}> */}
          <Copyable value={contractId}>{contractId}</Copyable>
        </>
      )}
    </>
  );
}

/*
    <Button
      onPress={onDeployClick}
      type='button'
      color='accent'
      isDisabled={!abi || !bytecode || deployState === DeployState.DEPLOYING}>
      {deployState === DeployState.NOT_DEPLOYED ? 'DEPLOY' : 'DEPLOYING'}
    </Button>
 */
