import { useQuery } from '@tanstack/react-query';
import { useWallet } from '@fuels/react';
import { Contract, Interface } from 'fuels';
import { loadAbi } from '../../../utils/localStorage';

export function useContract(contractId: string) {
  const { wallet, isLoading, isError } = useWallet();

  const {
    data: contract,
    isLoading: isContractLoading,
    isError: isContractError,
  } = useQuery({
    enabled: !isLoading && !isError && !!wallet && !!contractId.length,
    queryKey: ['contract'],
    queryFn: async () => {
      const cachedAbi = loadAbi();
      if (!!wallet && !!cachedAbi.length && !!contractId.length) {
        const abi: Interface = JSON.parse(cachedAbi);
        return new Contract(contractId, abi, wallet);
      }
    },
  });

  return { contract, isLoading: isContractLoading, isError: isContractError };
}
