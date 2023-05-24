import { AbstractAddress, Contract, Interface, Provider } from 'fuels';
import { FuelWalletLocked } from '@fuel-wallet/sdk';

export class Swaypad {
  static contract: Swaypad;
  readonly abi: Interface;

  constructor(abi: string) {
    this.abi = JSON.parse(abi);
  }

  connect(
    id: string | AbstractAddress,
    walletOrProvider: FuelWalletLocked | Provider
  ): Contract {
    return new Contract(id, this.abi, walletOrProvider);
  }
}
