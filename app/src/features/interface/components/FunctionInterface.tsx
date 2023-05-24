import { Stack } from '@fuel-ui/react';
import { Contract, FunctionFragment } from 'fuels';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { cssObj } from '@fuel-ui/css';
import { FunctionForm } from './FunctionForm';
import { FunctionReturnInfo } from './FunctionReturnInfo';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import { FormLabel, InputLabel, StepLabel } from '@mui/material';
import { InputInstance, ParamType } from './FunctionParameters';
import { Input } from '@mui/base';
import { FunctionCallAccordion } from './FunctionCallAccordion';
import { getInstantiableType } from '../utils/types';

export interface FunctionInterfaceProps {
  contractId: string;
  functionFragment: FunctionFragment | undefined;
  functionName: string;
  response: string;
  setResponse: (response: string) => void;
}

export function FunctionInterface({
  contractId,
  functionFragment,
  functionName,
  response,
  setResponse,
}: FunctionInterfaceProps) {
  // const [inputInstances, setInputInstances] = useState<InputInstance[]>([]);

  // const nestedType = useCallback((input: any) => {
  //   if (isFunctionPrimitive(input)) {
  //     return { name: input.name, type: getInstantiableType(input.type) };
  //   }

  //   return {
  //     name: input.name,
  //     // components: input.components.map((nested: any) => {
  //     //   return nestedType(nested);
  //     // }),
  //     components: [],
  //   };
  // }, []);

  // useEffect(() => {
  //   if (!!functionFragment) {
  //     const mappedInputs = functionFragment?.inputs.map((input) => {
  //       console.log('input', input);
  //       // return nestedType(input);
  //       return { name: input.name, type: getInstantiableType(input.type) };
  //     });
  //     setInputInstances(mappedInputs as InputInstance[]);
  //   }
  // }, [functionFragment]);

  // TODO: handle object types
  const inputInstances: InputInstance[] = useMemo(
    () =>
      functionFragment?.inputs.map((input) => {
        console.log('input', input);
        // return nestedType(input);
        return {
          name: input.name ?? '',
          type: getInstantiableType(input.type),
        };
      }) ?? [],
    [functionFragment?.inputs]
  );

  return (
    <FunctionCallAccordion
      contractId={contractId}
      functionName={functionName}
      inputInstances={inputInstances}
      response={response}
      setResponse={setResponse}
    />
  );
}
