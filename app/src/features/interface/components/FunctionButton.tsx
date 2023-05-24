import { FieldValues, UseFormWatch } from 'react-hook-form';
import { useCallFunction } from '../hooks';
import Button from '@mui/material/Button';
import { CallType } from '../../../utils/types';

interface FunctionButtonProps {
  //   inputInstances: { [k: string]: any }[];
  contractId: string;
  functionName: string;
  callType: CallType;
  //   functionValue: any;
  setResponse: (response: string) => void;
  //   watch: UseFormWatch<FieldValues>;
}

export function FunctionButton({
  //   inputInstances,
  contractId,
  functionName,
  callType,
  //   functionValue,
  setResponse,
}: //   watch,
FunctionButtonProps) {
  const functionMutation = useCallFunction({
    // inputInstances,
    contractId,
    functionName,
    callType,
    // functionValue,
    setResponse,
    // watch,
  });

  function onFunctionClick() {
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
