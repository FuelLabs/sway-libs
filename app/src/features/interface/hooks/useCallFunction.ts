import { useMutation } from '@tanstack/react-query';
import { useContract } from '.';
import { modifyJsonStringify } from '../utils/modifyJsonStringify';
import { displayError } from '../../../utils/error';
import { CallType } from '../../../utils/types';
import { CallableParamValue } from '../components/FunctionParameters';

interface CallFunctionProps {
  parameters: CallableParamValue[];
  contractId: string;
  functionName: string;
  callType: CallType;
  setResponse: (response: string) => void;
}

export function useCallFunction({
  parameters,
  contractId,
  functionName,
  callType,
  setResponse,
}: CallFunctionProps) {
  const { contract } = useContract(contractId);

  const mutation = useMutation(
    async () => {
      if (!contract) throw new Error('Contract not connected');

      const transactionResult = await contract.functions[functionName](
        ...parameters
      ) // TODO: fill params & do input validation
        [callType === 'dryrun' ? 'get' : 'call']();
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
    displayError(error);
    setResponse(`error: ${JSON.stringify(error?.message)}`);
  }

  function handleSuccess(data: any) {
    setResponse(JSON.stringify(data.value, modifyJsonStringify, 2));
  }

  return mutation;
}
