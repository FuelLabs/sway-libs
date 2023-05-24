import { Button } from '@fuel-ui/react';
import { DeployState } from '../../../utils/types';
import { displayError } from '../../../utils/error';
import { parseAddress } from '../../../utils/parseAddress';

interface UseDeployedContractButtonProps {
  abi: string;
  bytecode: string;
  setContractId: React.Dispatch<React.SetStateAction<string>>;
  setDeployState: React.Dispatch<React.SetStateAction<DeployState>>;
}

export function UseDeployedContractButton({
  abi,
  bytecode,
  setContractId,
  setDeployState,
}: UseDeployedContractButtonProps) {
  function onAlreadyDeployedContractClick() {
    const id = document.querySelector<HTMLInputElement>(
      '#deployedContractId'
    )?.value;
    if (id && parseAddress(id)) {
      setContractId(id);
      setDeployState(DeployState.DEPLOYED);
    } else {
      displayError('Invalid contract address');
    }
  }

  return (
    <Button
      onPress={onAlreadyDeployedContractClick}
      type='button'
      size='md'
      color='accent'
      isDisabled={!abi || !bytecode}>
      USE CONTRACT
    </Button>
  );
}
