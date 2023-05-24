import { Button, Copyable, Text } from '@fuel-ui/react';
import { cssObj } from '@fuel-ui/css';
import { DeployState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import { UseDeployedContractButton } from './UseDeployedContractButton';
import { UseDeployedContractForm } from './UseDeployedContractForm';

interface DeploymentButtonProps {
  abi: string;
  bytecode: string;
  contractId: string;
  setContractId: React.Dispatch<React.SetStateAction<string>>;
  deployState: DeployState;
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>;
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
          <Text> or </Text>
          <UseDeployedContractForm />
          <UseDeployedContractButton
            abi={abi}
            bytecode={bytecode}
            setContractId={setContractId}
            setDeployState={setDeployState}
          />
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

const styles = {
  contractAddress: cssObj({
    overflowWrap: 'anywhere',
    paddingLeft: '$5',
    paddingRight: '$5',
    color: '$gray7',
  }),
};
