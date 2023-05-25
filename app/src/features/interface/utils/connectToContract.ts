import { AbstractAddress, Contract, Interface, Provider } from 'fuels';
import { FuelWalletLocked } from '@fuel-wallet/sdk';
import { loadAbi } from '../../../utils/localStorage';

export function connectToContract(
  contractId: string | AbstractAddress,
  walletOrProvider: FuelWalletLocked | Provider
): Contract {
  const abi: Interface = JSON.parse(loadAbi());
  return new Contract(contractId, abi, walletOrProvider);
}
