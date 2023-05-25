import * as React from 'react';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import Table from '@mui/material/Table';
import Paper from '@mui/material/Paper';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import TableBody from '@mui/material/TableBody';
import ParameterInput from './ParameterInput';
import { TypeInfo } from '../utils/getTypeInfo';

// TODO: this is unnecessary
export type SimpleParamType = 'number' | 'bool' | 'string' | 'object';
export type SimpleParamValue = number | boolean | string;
export type ObjectParamValue = Record<
  string,
  SimpleParamValue | Record<string, any>
>;
export type CallableParamValue = SimpleParamValue | ObjectParamValue;

export interface InputInstance {
  name: string;
  type: TypeInfo;
  components: InputInstance[] | undefined;
}

interface FunctionParametersProps {
  inputInstances: InputInstance[];
  functionName: string;
  paramValues: SimpleParamValue[];
  setParamValues: (values: SimpleParamValue[]) => void;
}

export function FunctionParameters({
  inputInstances,
  functionName,
  paramValues,
  setParamValues,
}: FunctionParametersProps) {
  const setValueAtIndex = React.useCallback(
    (index: number, value: SimpleParamValue) => {
      const newParamValues = [...paramValues];
      newParamValues[index] = value;
      setParamValues(newParamValues);
    },
    [paramValues, setParamValues]
  );

  return (
    <TableContainer component={Paper}>
      <Table aria-label='function parameter table'>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Type</TableCell>
            <TableCell>Value</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {inputInstances.map((input, index) => (
            <TableRow
              key={functionName + input.name + index}
              sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
              <TableCell component='th' scope='row'>
                {input.name}
              </TableCell>
              <TableCell>{input.type.swayType}</TableCell>
              <TableCell style={{ width: '100%' }}>
                <ParameterInput
                  input={input}
                  value={paramValues[index]}
                  onChange={(value: SimpleParamValue) =>
                    setValueAtIndex(index, value)
                  }
                />
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}
