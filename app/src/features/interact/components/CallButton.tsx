import { useCallFunction } from "../hooks/useCallFunction";
import { CallType } from "../../../utils/types";
import { CallableParamValue } from "./FunctionParameters";
import SecondaryButton from "../../../components/SecondaryButton";
import { track } from "@vercel/analytics/react";
import { useCallback } from "react";

interface CallButtonProps {
  contractId: string;
  functionName: string;
  parameters: CallableParamValue[];
  callType: CallType;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function CallButton({
  contractId,
  functionName,
  parameters,
  callType,
  setResponse,
  updateLog,
}: CallButtonProps) {
  const functionMutation = useCallFunction({
    contractId,
    functionName,
    parameters,
    callType,
    setResponse,
    updateLog,
  });

  const onFunctionClick = useCallback(() => {
    track("Function Call Click", { callType });
    setResponse("");
    functionMutation.mutate();
  }, [callType, functionMutation, setResponse]);

  return (
    <SecondaryButton
      onClick={onFunctionClick}
      text="CALL"
      tooltip="Call the contract function with the provided arguments"
    />
  );
}
