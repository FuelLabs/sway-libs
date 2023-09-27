import { useMutation } from '@tanstack/react-query';
import { useContract } from './useContract';
import { modifyJsonStringify } from '../utils/modifyJsonStringify';
import { CallType } from '../../../utils/types';
import { CallableParamValue } from '../components/FunctionParameters';

interface CallFunctionProps {
  parameters: CallableParamValue[];
  contractId: string;
  functionName: string;
  callType: CallType;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function useCallFunction({
  parameters,
  contractId,
  functionName,
  callType,
  setResponse,
  updateLog,
}: CallFunctionProps) {
  const { contract } = useContract(contractId);

  const mutation = useMutation(
    async () => {
      updateLog(
        `Calling ${functionName} with parameters ${JSON.stringify(parameters)}${
          callType === 'dryrun' ? ' (DRY RUN)' : ''
        }`
      );

      if (!contract) throw new Error('Contract not connected');

      const functionCaller = contract.functions[functionName](
        ...parameters
      );
      const transactionResult = callType === 'dryrun' ? await functionCaller.dryRun() : await functionCaller.call();
      return transactionResult;
    },
    {
      onSuccess: (data) => {
        handleSuccess(data);
      },
      onError: handleError,
    }
  );

  function handleError(error: any) {
    updateLog(`Function call failed. Error: ${error?.message}`);
    setResponse(new Error(error?.message));
  }

  function handleSuccess(data: any) {
    setResponse(JSON.stringify(data.value, modifyJsonStringify, 2));
  }

  return mutation;
}
