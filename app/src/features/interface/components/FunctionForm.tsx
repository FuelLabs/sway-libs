import { Form } from '@fuel-ui/react';
import FunctionToolbar from './FunctionToolbar';
import {
  FunctionParameters,
  InputInstance,
  SimpleParamValue,
} from './FunctionParameters';
import React, { useEffect, useMemo, useState } from 'react';

interface FunctionFormProps {
  contractId: string;
  functionName: string;
  // response: string;
  setResponse: (response: string) => void;
  inputInstances: InputInstance[];
}

export function FunctionForm({
  contractId,
  setResponse,
  functionName,
  inputInstances,
}: FunctionFormProps) {
  const [paramValues, setParamValues] = useState(
    Array<SimpleParamValue>(inputInstances.length)
  );

  useEffect(() => {
    console.log('paramValues');
    console.log(JSON.stringify(paramValues));
  }, [paramValues]);

  const transformedParams = useMemo(() => {
    return paramValues.map((paramValue) => {
      console.log(`typeof pv: ${typeof paramValue}`);
      if (typeof paramValue === 'string') {
        try {
          // Try to parse the string as JSON
          // TODO: support JSON strings, check the actual field type
          return JSON.parse(paramValue);
        } catch (e) {}
      }
      return paramValue;
    });
  }, [paramValues]);

  return (
    <div>
      <Form.Control className={contractId + functionName}>
        <div>
          <FunctionToolbar
            contractId={contractId}
            functionName={functionName}
            parameters={transformedParams}
            setResponse={setResponse}
          />

          <FunctionParameters
            inputInstances={inputInstances as InputInstance[]}
            functionName={functionName}
            paramValues={paramValues}
            setParamValues={setParamValues}
          />
        </div>
      </Form.Control>
    </div>
  );
}
