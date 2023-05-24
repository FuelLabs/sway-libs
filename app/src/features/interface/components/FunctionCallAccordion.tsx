import React from 'react';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import { FormLabel } from '@mui/material';
import { InputInstance } from './FunctionParameters';
import { FunctionForm } from './FunctionForm';
import { FunctionReturnInfo } from './FunctionReturnInfo';

export interface FunctionCallAccordionProps {
  contractId: string;
  functionName: string;
  inputInstances: InputInstance[];
  response: string;
  setResponse: (response: string) => void;
}

export function FunctionCallAccordion({
  contractId,
  functionName,
  inputInstances,
  response,
  setResponse,
}: FunctionCallAccordionProps) {
  return (
    <Accordion key={functionName}>
      <AccordionSummary expandIcon={<ExpandMoreIcon />}>
        <FormLabel style={{ fontFamily: 'monospace', color: '#00000099' }}>
          {functionName}
        </FormLabel>
      </AccordionSummary>
      <AccordionDetails>
        <FunctionForm
          contractId={contractId}
          functionName={functionName}
          inputInstances={inputInstances}
          setResponse={setResponse}
        />
        <FunctionReturnInfo response={response} />
      </AccordionDetails>
    </Accordion>
  );
}
