import { useQuery } from '@tanstack/react-query';
import { useContract } from './useContract';
import { Contract } from 'fuels';

export function useContractFunctions(contractId: string): {
  contract: Contract | undefined;
  functionNames: string[];
} {
  const { contract } = useContract(contractId);

  const { data: functions } = useQuery({
    enabled: !!contract,
    queryKey: ['contractFunctions'],
    queryFn: async () => {
      if (!contract) throw new Error('Contract not connected');
      return contract.interface.functions;
    },
  });

  return {
    contract,
    functionNames: functions ? [...Object.keys(functions)] : [],
  };
}
