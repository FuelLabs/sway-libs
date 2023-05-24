import { Stack } from '@fuel-ui/react';
import { Contract, FunctionFragment } from 'fuels';
import { useCallback, useEffect, useState } from 'react';
import { getInstantiableType, isFunctionPrimitive } from '../utils';
import { cssObj } from '@fuel-ui/css';
import { FunctionForm } from './FunctionForm';
import { FunctionReturnInfo } from './FunctionReturnInfo';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import { FormLabel, InputLabel, StepLabel } from '@mui/material';
import { InputInstance } from './FunctionParameters';
import { Input } from '@mui/base';
import { FunctionCallAccordion } from './FunctionCallAccordion';

export interface FunctionInterfaceProps {
  contractId: string;
  functionFragment: FunctionFragment | undefined;
  response: string;
  setResponse: (response: string) => void;
}

export function FunctionInterface({
  contractId,
  functionFragment,
  response,
  setResponse,
}: FunctionInterfaceProps) {
  const [inputInstances, setInputInstances] = useState<InputInstance[]>([]);

  const [initialized, setInitialized] = useState<boolean>(false);

  const nestedType = useCallback((input: any) => {
    if (isFunctionPrimitive(input)) {
      return { name: input.name, type: getInstantiableType(input.type) };
    }

    return {
      name: input.name,
      components: input.components.map((nested: any) => {
        return nestedType(nested);
      }),
    };
  }, []);

  useEffect(() => {
    if (!initialized && functionFragment) {
      const mappedInputs = functionFragment.inputs.map((input) => {
        return nestedType(input);
      });
      setInputInstances(mappedInputs as InputInstance[]);
      setInitialized(true);
    }
  }, [functionFragment, initialized, nestedType]);

  return functionFragment?.name ? (
    <FunctionCallAccordion
      contractId={contractId}
      functionName={functionFragment.name}
      inputInstances={inputInstances}
      response={response}
      setResponse={setResponse}
    />
  ) : (
    <></>
  );
}
