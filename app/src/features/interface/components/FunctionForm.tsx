import { cssObj } from '@fuel-ui/css';
import { Form, Box, Heading, Stack } from '@fuel-ui/react';
import { useForm } from 'react-hook-form';
import { FunctionButtons } from './FunctionButtons';
import {
  FunctionParameters,
  InputInstance,
  ParamValueType,
} from './FunctionParameters';
import ObjectParameterInput from './ObjectParameterInput';
import React, { useState } from 'react';

interface FunctionFormProps {
  contractId: string;
  functionName: string;
  // response: string;
  setResponse: (response: string) => void;
  inputInstances: InputInstance[];
}

export function FunctionForm({
  contractId,
  // response,
  setResponse,
  functionName,
  inputInstances,
}: FunctionFormProps) {
  const [paramValues, setParamValues] = useState(
    Array<ParamValueType>(inputInstances.length)
  );

  // const { register, handleSubmit, watch, setValue } = useForm();

  return (
    <div>
      <Form.Control className={contractId + functionName}>
        <div>
          <div style={{ float: 'left', width: '80%' }}>
            {/* <ObjectParameterInput /> */}
            <FunctionParameters
              inputInstances={inputInstances as InputInstance[]}
              functionName={functionName}
              // register={register}
              paramValues={paramValues}
              setParamValues={setParamValues}
            />
          </div>

          <div style={{ float: 'left', width: '20%' }}>
            <FunctionButtons
              // inputInstances={inputInstances as InputInstance[]}
              contractId={contractId}
              functionName={functionName}
              // response={response}
              setResponse={setResponse}
              // watch={watch}
            />
          </div>
        </div>
      </Form.Control>
    </div>
  );
}
