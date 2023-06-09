import React from 'react';
import { InputInstance, SimpleParamValue } from './FunctionParameters';
import TextField from '@mui/material/TextField';
import ToggleButton from '@mui/material/ToggleButton';
import ToggleButtonGroup from '@mui/material/ToggleButtonGroup';
import ComplexParameterInput from './ComplexParameterInput';

export interface ParameterInputProps {
  input: InputInstance;
  value: SimpleParamValue;
  onChange: (value: SimpleParamValue) => void;
}

function ParameterInput({ input, value, onChange }: ParameterInputProps) {
  switch (input.type.literal) {
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
    case 'vector':
    case 'enum':
    case 'option':
    case 'object':
      return (
        <ComplexParameterInput
          input={input}
          value={value as string}
          onChange={onChange}
        />
      );
  }
}

export default ParameterInput;
