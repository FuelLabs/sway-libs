import { FunctionFragment } from 'fuels';
import { useCallback, useMemo } from 'react';
import { InputInstance } from './FunctionParameters';
import { FunctionCallAccordion } from './FunctionCallAccordion';
import { getTypeInfo } from '../utils/getTypeInfo';

export interface SdkParamType {
  name?: string;
  type: string;
  components?: SdkParamType[];
  typeArguments?: SdkParamType[];
}

export interface FunctionInterfaceProps {
  contractId: string;
  functionFragment: FunctionFragment | undefined;
  functionName: string;
  response: string;
  setResponse: (response: string) => void;
  updateLog: (entry: string) => void;
}

export function FunctionInterface({
  contractId,
  functionFragment,
  functionName,
  response,
  setResponse,
  updateLog,
}: FunctionInterfaceProps) {
  const toInputInstance = useCallback((input: SdkParamType): InputInstance => {
    const typeInfo = getTypeInfo(input);
    switch (typeInfo.literal) {
      case 'vector':
        return {
          name: input.name ?? '',
          type: typeInfo,
          components: [toInputInstance(input.typeArguments![0])],
        };
      case 'object':
        return {
          name: input.name ?? '',
          type: typeInfo,
          components: input.components?.map(toInputInstance),
        };
      case 'option':
      case 'enum':
        return {
          name: input.name ?? '',
          type: typeInfo,
          components: [toInputInstance(input.components![0])],
        };
      default:
        return {
          name: input.name ?? '',
          type: typeInfo,
        };
    }
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
      updateLog={updateLog}
    />
  );
}
