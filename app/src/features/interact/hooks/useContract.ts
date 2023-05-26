import { useQuery } from '@tanstack/react-query';
import { useWallet } from '../../toolbar/hooks/useWallet';
import { AbstractAddress, Contract, Interface, Provider } from 'fuels';
import { FuelWalletLocked } from '@fuel-wallet/sdk';
import { loadAbi } from '../../../utils/localStorage';

function connectToContract(
  contractId: string | AbstractAddress,
  walletOrProvider: FuelWalletLocked | Provider
): Contract {
  const abi: Interface = JSON.parse(loadAbi());
  return new Contract(contractId, abi, walletOrProvider);
}

export function useContract(contractId: string) {
  const { wallet, isLoading, isError } = useWallet();

  const {
    data: contract,
    isLoading: isContractLoading,
    isError: isContractError,
  } = useQuery(
    ['contract', contractId],
    async () => {
      if (!!wallet) {
        const abi: Interface = JSON.parse(loadAbi());
        return new Contract(contractId, abi, wallet);
      }
    },
    {
      enabled: !isLoading && !isError && !!wallet,
    }
  );

  return { contract, isLoading: isContractLoading, isError: isContractError };
}
