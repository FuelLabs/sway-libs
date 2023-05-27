import React from 'react';
import { NetworkState, DeployState } from '../../../utils/types';
import { ContractInterface } from './ContractInterface';
import useNetwork from '../../toolbar/hooks/useNetwork';

export interface InterfaceProps {
  contractId: string;
  setDeployState: (state: DeployState) => void;
  setNetwork: (network: string) => void;
}

export function Interface({
  contractId,
  setDeployState,
  setNetwork,
}: InterfaceProps) {
  useNetwork(setNetwork, setDeployState);
  return <ContractInterface key={contractId} contractId={contractId} />;
}
