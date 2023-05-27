import { useQuery } from '@tanstack/react-query';
import { useWallet } from '../../toolbar/hooks/useWallet';
import { Contract, Interface } from 'fuels';
import { loadAbi } from '../../../utils/localStorage';

export function useContract(contractId: string) {
  const { wallet, isLoading, isError } = useWallet();

  const {
    data: contract,
    isLoading: isContractLoading,
    isError: isContractError,
  } = useQuery(
    ['contract'],
    async () => {
      const cachedAbi = loadAbi();
      if (!!wallet && !!cachedAbi.length && !!contractId.length) {
        const abi: Interface = JSON.parse(cachedAbi);
        return new Contract(contractId, abi, wallet);
      }
    },
    {
      enabled: !isLoading && !isError && !!wallet && !!contractId.length,
    }
  );

  return { contract, isLoading: isContractLoading, isError: isContractError };
}
