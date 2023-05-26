import Button from '@mui/material/Button';
import { DeployState } from '../../../utils/types';
import { useDeployContract } from '../hooks/useDeployContract';
import { colorKeys, darkColors } from '@fuel-ui/css';
import { lightColors } from '@fuel-ui/css';
import { Spinner } from '@fuel-ui/react';
import Tooltip from '@mui/material/Tooltip';
import SecondaryButton from '../../toolbar/components/SecondaryButton';
import { ButtonSpinner } from '../../../components/shared';

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
