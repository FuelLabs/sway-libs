import { Box, BoxCentered, Stack } from '@fuel-ui/react';
import { Dispatch, SetStateAction, useState } from 'react';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { NetworkState, DeployState } from '../../../utils/types';
import { ContractInterface } from './ContractInterface';
// import { ConnectionButton } from '../../toolbar/components/ConnectionButton';
import { DeploymentButton } from '../../deploy/components/DeploymentButton';
import useNetwork from '../../toolbar/hooks/useNetwork';

export interface InterfaceProps {
  deployState: DeployState;
  networkState: NetworkState;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
}

export function Interface({
  deployState,
  networkState,
  setDeployState,
  setNetwork,
}: InterfaceProps) {
  const [contractId, setContractId] = useState('');
  useNetwork(setNetwork, setDeployState);

  return (
    <Box>
      <BoxCentered minHS>
        <Stack align={'center'}>
          {/* {
            <ConnectionButton
              setDeployState={setDeployState}
              setNetwork={setNetwork}
              networkState={networkState}
              setNetworkState={setNetworkState}
            />
          } */}
          {(networkState === NetworkState.CAN_DISCONNECT ||
            networkState === NetworkState.DISCONNECTING) && (
            <DeploymentButton
              abi={loadAbi()}
              bytecode={loadBytecode()}
              contractId={contractId}
              setContractId={setContractId}
              deployState={deployState}
              setDeployState={setDeployState}
            />
          )}
          {deployState === DeployState.DEPLOYED &&
            (networkState === NetworkState.CAN_DISCONNECT ||
              networkState === NetworkState.DISCONNECTING) && (
              <ContractInterface key={contractId} contractId={contractId} />
            )}
        </Stack>
      </BoxCentered>
    </Box>
  );
}
