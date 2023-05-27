import { useCallFunction } from '../hooks';
import { CallType } from '../../../utils/types';
import { CallableParamValue } from './FunctionParameters';
import SecondaryButton from '../../../components/SecondaryButton';

interface CallButtonProps {
  contractId: string;
  functionName: string;
  parameters: CallableParamValue[];
  callType: CallType;
  setResponse: (response: string) => void;
}

export function CallButton({
  contractId,
  functionName,
  parameters,
  callType,
  setResponse,
}: CallButtonProps) {
  const functionMutation = useCallFunction({
    contractId,
    functionName,
    parameters,
    callType,
    setResponse,
  });

  function onFunctionClick() {
    setResponse('');
    functionMutation.mutate();
  }

  return (
    <SecondaryButton
      onClick={onFunctionClick}
      text='CALL'
      tooltip='Call the contract function with the provided arguments'
    />
  );
}
