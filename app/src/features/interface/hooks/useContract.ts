import { useQuery } from '@tanstack/react-query';
import { connectToContract } from '../utils/connectToContract';
import { useWallet } from '../../wallet/hooks/useWallet';

export function useContract(contractId: string) {
  const { wallet, isLoading, isError } = useWallet();

  const {
    data: contract,
    isLoading: isContractLoading,
    isError: isContractError,
  } = useQuery(
    ['contract', contractId],
    async () => {
      return connectToContract(contractId, wallet!);
    },
    {
      enabled: !isLoading && !isError && !!wallet,
    }
  );

  return { contract, isLoading: isContractLoading, isError: isContractError };
}
