import { cssObj } from '@fuel-ui/css';
import { Box, BoxCentered, Stack } from '@fuel-ui/react';
import { Dispatch, SetStateAction, useState } from 'react';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { NetworkState, DeployState } from '../../../utils/types';
import useNetwork from '../../wallet/hooks/useNetwork';
import { ContractInterface } from './ContractInterface';
import { ConnectionButton } from '../../wallet/components/ConnectionButton';
import { DeploymentButton } from '../../deploy/components/DeploymentButton';

export interface InterfaceProps {
  deployState: DeployState;
  setDeployState: Dispatch<SetStateAction<DeployState>>;
}

export function Interface({ deployState, setDeployState }: InterfaceProps) {
  const [contractId, setContractId] = useState('');
  const [network, setNetwork] = useState('');
  const [networkState, setNetworkState] = useState(NetworkState.CAN_CONNECT);
  useNetwork(setNetwork, setDeployState);

  return (
    // <Box css={styles.contentWrapper}>
    <Box>
      {/* click is triggered by playground.js on contract compile */}
      {/* <div className='ui' onClick={onContractCompile} /> */}
      {/* <BoxCentered minHS css={styles.contractInterface}> */}
      <BoxCentered minHS>
        <Stack align={'center'}>
          {
            <ConnectionButton
              setDeployState={setDeployState}
              setNetwork={setNetwork}
              networkState={networkState}
              setNetworkState={setNetworkState}
            />
          }
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

const styles = {
  contentWrapper: cssObj({
    height: '100%',
    width: '50%',
    right: '0',
    position: 'fixed',
    overflow: 'scroll',
  }),
  contractInterface: cssObj({
    paddingBottom: '$10',
  }),
};
