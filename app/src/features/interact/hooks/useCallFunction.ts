import { useMutation } from "@tanstack/react-query";
import { useContract } from "./useContract";
import { modifyJsonStringify } from "../utils/modifyJsonStringify";
import { CallType } from "../../../utils/types";
import { CallableParamValue } from "../components/FunctionParameters";
import { FunctionInvocationResult, InvocationCallResult } from "fuels";

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

  const mutation = useMutation({
    onSuccess: (data) => {
      handleSuccess(data);
    },
    onError: handleError,
    mutationFn: async () => {
      updateLog(
        `Calling ${functionName} with parameters ${JSON.stringify(parameters)}${
          callType === "dryrun" ? " (DRY RUN)" : ""
        }`,
      );

      if (!contract) throw new Error("Contract not connected");

      const functionHandle = contract.functions[functionName];
      const functionCaller = functionHandle(...parameters);
      const transactionResult =
        callType === "dryrun" || functionHandle.isReadOnly()
          ? await functionCaller.dryRun()
          : await functionCaller.call();
      return transactionResult;
    },
  });

  function handleError(error: Error) {
    updateLog(`Function call failed. Error: ${error?.message}`);
    setResponse(new Error(error?.message));
  }

  function handleSuccess(
    data:
      | InvocationCallResult<unknown>
      | FunctionInvocationResult<unknown, void>,
  ) {
    setResponse(JSON.stringify(data.value, modifyJsonStringify, 2));
  }

  return mutation;
}
