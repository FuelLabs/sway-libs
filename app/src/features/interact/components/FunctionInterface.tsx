import { FunctionFragment } from "fuels";
import { useCallback, useMemo } from "react";
import { InputInstance } from "./FunctionParameters";
import { FunctionCallAccordion } from "./FunctionCallAccordion";
import { getTypeInfo } from "../utils/getTypeInfo";
import React from "react";
import { AbiHelper } from "../utils/abi";

export interface FunctionInterfaceProps {
  contractId: string;
  abiHelper: AbiHelper;
  functionFragment: FunctionFragment | undefined;
  functionName: string;
  response?: string | Error;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function FunctionInterface({
  contractId,
  abiHelper,
  functionFragment,
  functionName,
  response,
  setResponse,
  updateLog,
}: FunctionInterfaceProps) {
  const toInputInstance = useCallback(
    (typeId: string | number, name: string): InputInstance => {
      const { concreteType, metadataType } = abiHelper.getTypesById(typeId);
      const typeInfo = getTypeInfo(concreteType, abiHelper);

      switch (typeInfo.literal) {
        case "vector":
          return {
            name,
            type: typeInfo,
            components: [
              toInputInstance(concreteType?.typeArguments?.at(0) ?? "", ""),
            ],
          };
        case "object":
          return {
            name,
            type: typeInfo,
            components: metadataType?.components?.map((c) =>
              toInputInstance(c.typeId, c.name),
            ),
          };
        case "option":
        case "enum":
          return {
            name,
            type: typeInfo,
            components: [
              toInputInstance(
                metadataType?.components?.at(0)?.typeId ?? "",
                metadataType?.components?.at(0)?.name ?? "",
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
    [abiHelper],
  );

  const outputType = useMemo(() => {
    const outputTypeId = functionFragment?.jsonFn?.output;
    if (outputTypeId !== undefined) {
      const sdkType = abiHelper.getConcreteTypeById(outputTypeId);
      return sdkType ? getTypeInfo(sdkType, abiHelper).literal : undefined;
    }
  }, [functionFragment?.jsonFn?.output, abiHelper]);

  const inputInstances: InputInstance[] = useMemo(
    () =>
      functionFragment?.jsonFn?.inputs.map((input) =>
        toInputInstance(input.concreteTypeId, input.name),
      ) ?? [],
    [functionFragment?.jsonFn?.inputs, toInputInstance],
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
