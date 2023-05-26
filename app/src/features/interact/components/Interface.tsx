import { Box, BoxCentered, Copyable, Stack } from '@fuel-ui/react';
import { Dispatch, SetStateAction, useState } from 'react';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { NetworkState, DeployState } from '../../../utils/types';
import { ContractInterface } from './ContractInterface';
// import { ConnectionButton } from '../../toolbar/components/ConnectionButton';
import { DeploymentButton } from '../../deploy/components/DeploymentButton';
import useNetwork from '../../toolbar/hooks/useNetwork';

export interface InterfaceProps {
  contractId: string;
  deployState: DeployState;
  networkState: NetworkState;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
}

export function Interface({
  contractId,
  deployState,
  networkState,
  setDeployState,
  setNetwork,
}: InterfaceProps) {
  useNetwork(setNetwork, setDeployState);

  console.log(networkState.toString());

  console.log(deployState.toString());

  // if (deployState === DeployState.DEPLOYED) {
  return <ContractInterface key={contractId} contractId={contractId} />;

  // if (

  //   [NetworkState.CAN_DISCONNECT, NetworkState.DISCONNECTING].includes(
  //     networkState
  //   )
  // ) {
  //   return <ContractInterface key={contractId} contractId={contractId} />;
  // } else {
  //   return <div>Connect your wallet to interact with the network.</div>;
  // }
  // } else {
  //   return (
  //   );
  // }
}
