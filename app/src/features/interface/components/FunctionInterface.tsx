import { FunctionFragment } from 'fuels';
import { useCallback, useMemo } from 'react';
import { InputInstance } from './FunctionParameters';
import { FunctionCallAccordion } from './FunctionCallAccordion';
import { getTypeInfo } from '../utils/getTypeInfo';

interface SdkParamType {
  name: string | undefined;
  type: string;
  components: SdkParamType[] | undefined;
}

export interface FunctionInterfaceProps {
  contractId: string;
  functionFragment: FunctionFragment | undefined;
  functionName: string;
  response: string;
  setResponse: (response: string) => void;
}

export function FunctionInterface({
  contractId,
  functionFragment,
  functionName,
  response,
  setResponse,
}: FunctionInterfaceProps) {
  const toInputInstance = useCallback((input: SdkParamType): InputInstance => {
    return {
      name: input.name ?? '',
      type: getTypeInfo(input.type),
      components: input.components?.map(toInputInstance),
    };
  }, []);

  const inputInstances: InputInstance[] = useMemo(
    () =>
      functionFragment?.inputs.map((input) =>
        toInputInstance(input as SdkParamType)
      ) ?? [],
    [functionFragment?.inputs, toInputInstance]
  );

  return (
    <FunctionCallAccordion
      contractId={contractId}
      functionName={functionName}
      inputInstances={inputInstances}
      response={response}
      setResponse={setResponse}
    />
  );
}
