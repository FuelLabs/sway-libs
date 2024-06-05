import FunctionToolbar from "./FunctionToolbar";
import {
  CallableParamValue,
  FunctionParameters,
  InputInstance,
  SimpleParamValue,
} from "./FunctionParameters";
import React, { useMemo, useState } from "react";

interface FunctionFormProps {
  contractId: string;
  functionName: string;
  inputInstances: InputInstance[];
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function FunctionForm({
  contractId,
  setResponse,
  functionName,
  inputInstances,
  updateLog,
}: FunctionFormProps) {
  const [paramValues, setParamValues] = useState(
    Array<SimpleParamValue>(inputInstances.length),
  );

  // Parse complex parameters stored as strings.
  const transformedParams: CallableParamValue[] = useMemo(() => {
    return paramValues.map((paramValue, index) => {
      const input = inputInstances[index];
      const literal = input.type.literal;
      if (
        typeof paramValue === "string" &&
        ["vector", "object", "option", "enum"].includes(literal)
      ) {
        try {
          const parsed = JSON.parse(paramValue);

          // For Options, SDK expects to receive the value of "Some" or undefined for "None".
          if (literal === "option") {
            return parsed["Some"];
          }
          return parsed;
        } catch (e) {
          // We shouldn't get here, but if we do, the server will return an error.
        }
      }
      return paramValue;
    });
  }, [inputInstances, paramValues]);

  return (
    <div>
      <FunctionToolbar
        contractId={contractId}
        functionName={functionName}
        parameters={transformedParams}
        setResponse={setResponse}
        updateLog={updateLog}
      />

      <FunctionParameters
        inputInstances={inputInstances}
        functionName={functionName}
        paramValues={paramValues}
        setParamValues={setParamValues}
      />
    </div>
  );
}
