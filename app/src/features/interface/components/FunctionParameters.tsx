import * as React from 'react';
import { Box, Stack } from '@fuel-ui/react';
import { FieldValues, UseFormRegister, UseFormSetValue } from 'react-hook-form';
import { FunctionParameterNested } from './FunctionParameterNested';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import Table from '@mui/material/Table';
import Paper from '@mui/material/Paper';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import TableBody from '@mui/material/TableBody';
import { Input } from '@mui/material';
import ParameterInput from './ParameterInput';

export type ParamType = 'number' | 'boolean' | 'object';
export type ParamValueType = number | boolean | Record<string, any>;

export interface InputInstance {
  name: string;
  type: {
    type: ParamType;
  };
}

interface FunctionParametersProps {
  inputInstances: InputInstance[];
  functionName: string;
  paramValues: ParamValueType[];
  setParamValues: (values: ParamValueType[]) => void;
}

export function FunctionParameters({
  inputInstances,
  functionName,
  paramValues,
  setParamValues,
}: FunctionParametersProps) {
  function setValueAtIndex(index: number, value: ParamValueType) {
    const newParamValues = [...paramValues];
    newParamValues[index] = value;
    setParamValues(newParamValues);
  }

  // function functionParameterElements() {

  // console.log('paramValues', paramValues);

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
          {inputInstances.map(
            (
              input: any, // TODO: no any
              index: number
            ) => (
              <TableRow key={functionName + input.name + index}>
                <TableCell component='th' scope='row'>
                  {input.name}
                </TableCell>
                <TableCell>{input.type.type}</TableCell>
                <TableCell>
                  <ParameterInput
                    type={input.type.type}
                    onChange={(value: ParamValueType) =>
                      setValueAtIndex(index, value)
                    }
                  />
                </TableCell>
              </TableRow>
            )
          )}
        </TableBody>
      </Table>
    </TableContainer>
  );
  // return inputInstances.map((input: any, index: number) => (
  //   <Stack key={input.name + index}>
  //     <FunctionParameterNested
  //       name={`${functionName}.${input.name}`}
  //       input={input}
  //       index={index}
  //       register={register}
  //       setValue={setValue}
  //     />
  //   </Stack>
  // ));
  // }

  // return (
  //   <Box>
  //     <Stack>{functionParameterElements()}</Stack>
  //   </Box>
  // );
}
