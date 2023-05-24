import { useMutation } from '@tanstack/react-query';
import { FieldValues, UseFormWatch } from 'react-hook-form';
import { useContract } from '.';
import { getFunctionParameters, modifyJsonStringify } from '../utils';
import { displayError } from '../../../utils/error';
import { CallType } from '../../../utils/types';

interface CallFunctionProps {
  // inputInstances: { [k: string]: any }[];
  contractId: string;
  functionName: string;
  callType: CallType;
  // functionValue: any;
  setResponse: (response: string) => void;
  // watch: UseFormWatch<FieldValues>;
}

export function useCallFunction({
  // inputInstances,
  contractId,
  functionName,
  callType,
  // functionValue,
  setResponse,
}: // watch,
CallFunctionProps) {
  const { contract } = useContract(contractId);

  const mutation = useMutation(
    async () => {
      if (!contract) throw new Error('Contract not connected');

      // setFunctionValue({ [contractId + functionName]: '' });

      // const functionParameters = getFunctionParameters(
      //   inputInstances,
      //   watch,
      //   functionName
      // );

      const transactionResult = await contract.functions[functionName](111) // TODO: fill params & do input validation
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
