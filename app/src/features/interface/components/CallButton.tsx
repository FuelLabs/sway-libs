import { useCallFunction } from '../hooks';
import Button from '@mui/material/Button';
import { CallType } from '../../../utils/types';
import { CallableParamValue } from './FunctionParameters';

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
    <Button
      onClick={onFunctionClick}
      color='primary'
      variant='outlined'
      type='submit'
      size='large'>
      {'CALL'}
    </Button>
  );
}
