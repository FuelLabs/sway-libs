import { useQuery } from '@tanstack/react-query';
import { useContract } from './useContract';
import { Contract } from 'fuels';

export function useContractFunctions(contractId: string): { contract: Contract | undefined; functionNames: string[] } {
  const { contract } = useContract(contractId);

  const { data: functions } = useQuery(
    ['contractFunctions'],
    async () => {
      if (!contract) throw new Error('Contract not connected');
      return contract.interface.functions;
    },
    {
      enabled: !!contract,
    }
  );

  return {
    contract,
    functionNames: functions ? [...Object.keys(functions)] : [],
  };
}
