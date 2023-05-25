import React from 'react';
import { SimpleParamValue, InputInstance } from './FunctionParameters';
import TextField from '@mui/material/TextField';
import ToggleButton from '@mui/material/ToggleButton';
import ToggleButtonGroup from '@mui/material/ToggleButtonGroup';
import ObjectParameterInput from './ObjectParameterInput';

export interface ParameterInputProps {
  input: InputInstance;
  value: SimpleParamValue;
  onChange: (value: SimpleParamValue) => void;
}

function ParameterInput({ input, value, onChange }: ParameterInputProps) {
  // TODO: switch on value instead
  switch (input.type.simpleType) {
    case 'string':
      return (
        <TextField
          size='small'
          onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
            onChange(event.target.value);
          }}
        />
      );
    case 'number':
      return (
        <TextField
          size='small'
          type='number'
          onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
            onChange(Number.parseFloat(event.target.value));
          }}
        />
      );
    case 'bool':
      return (
        <ToggleButtonGroup
          size='small'
          color='primary'
          value={`${!!value}`}
          exclusive
          onChange={() => onChange(!value)}>
          <ToggleButton value='true'>true</ToggleButton>
          <ToggleButton value='false'>false</ToggleButton>
        </ToggleButtonGroup>
      );
    case 'object':
      return (
        <ObjectParameterInput
          input={input}
          value={value as string}
          onChange={onChange}
        />
      );
  }
}

export default ParameterInput;
