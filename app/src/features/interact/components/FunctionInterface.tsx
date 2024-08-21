import { FunctionFragment } from "fuels";
import { useCallback, useMemo } from "react";
import { InputInstance } from "./FunctionParameters";
import { FunctionCallAccordion } from "./FunctionCallAccordion";
import { getTypeInfo } from "../utils/getTypeInfo";
import { AbiTypeMap } from "./ContractInterface";
import React from "react";

export interface SdkJsonAbiArgument {
  readonly type: number;
  readonly name: string;
  readonly typeArguments: readonly SdkJsonAbiArgument[] | null;
}

export interface SdkJsonAbiType {
  readonly typeId: number;
  readonly type: string;
  readonly components: readonly SdkJsonAbiArgument[] | null;
  readonly typeParameters: readonly number[] | null;
}

export interface FunctionInterfaceProps {
  contractId: string;
  typeMap: AbiTypeMap;
  functionFragment: FunctionFragment | undefined;
  functionName: string;
  response?: string | Error;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function FunctionInterface({
  contractId,
  typeMap,
  functionFragment,
  functionName,
  response,
  setResponse,
  updateLog,
}: FunctionInterfaceProps) {
  const toInputInstance = useCallback(
    (typeId: number, name: string): InputInstance => {
      const input = typeMap?.get(typeId);
      if (!input) {
        return {
          name,
          type: {
            literal: "string",
            swayType: "Unknown",
          },
        };
      }
      const typeInfo = getTypeInfo(input, typeMap);
      switch (typeInfo.literal) {
        case "vector":
          return {
            name,
            type: typeInfo,
            components: [toInputInstance(input.typeParameters?.at(0) ?? 0, "")],
          };
        case "object":
          return {
            name,
            type: typeInfo,
            components: input.components?.map((c) =>
              toInputInstance(c.type, c.name),
            ),
          };
        case "option":
        case "enum":
          return {
            name,
            type: typeInfo,
            components: [
              toInputInstance(
                input.components?.at(0)?.type ?? 0,
                input.components?.at(0)?.name ?? "",
              ),
            ],
          };
        default:
          return {
            name,
            type: typeInfo,
          };
      }
    },
    [typeMap],
  );

  const outputType = useMemo(() => {
    // const outputTypeId = functionFragment?.jsonFn.output?.type;
    const outputTypeId = 0; // TODO
    if (outputTypeId !== undefined) {
      const sdkType = typeMap.get(outputTypeId);
      return sdkType ? getTypeInfo(sdkType, typeMap).literal : undefined;
    }
  }, [functionFragment?.jsonFn.output, typeMap]);

  const inputInstances: InputInstance[] = useMemo(
    () =>
      functionFragment?.jsonFn.inputs.map(
        (input) => toInputInstance(0, input.name), // TODO
        // toInputInstance(input.type, input.name),
      ) ?? [],
    [functionFragment?.jsonFn.inputs, toInputInstance],
  );

  return (
    <FunctionCallAccordion
      contractId={contractId}
      functionName={functionName}
      inputInstances={inputInstances}
      outputType={outputType}
      response={response}
      setResponse={setResponse}
      updateLog={updateLog}
    />
  );
}
