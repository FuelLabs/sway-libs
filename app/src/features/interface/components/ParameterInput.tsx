import React from 'react';
import Input from '@mui/material/Input';
import { ParamType, ParamValueType } from './FunctionParameters';

export interface ParameterInputProps {
  type: ParamType;
  onChange: (value: ParamValueType) => void;
}

function ParameterInput({ type, onChange }: ParameterInputProps) {
  return <Input onChange={onChange} />;
}

export default ParameterInput;
