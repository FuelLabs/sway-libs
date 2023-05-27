import { Box, BoxCentered, Copyable, Stack } from '@fuel-ui/react';
import { Dispatch, SetStateAction, useState } from 'react';
import { loadAbi, loadBytecode } from '../../../utils/localStorage';
import { NetworkState, DeployState } from '../../../utils/types';
import { ContractInterface } from './ContractInterface';
// import { ConnectionButton } from '../../toolbar/components/ConnectionButton';
import { DeploymentButton } from '../../toolbar/components/DeploymentButton';
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
  return <ContractInterface key={contractId} contractId={contractId} />;
}
