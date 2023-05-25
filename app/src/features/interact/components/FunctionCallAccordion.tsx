import React from 'react';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import { FormLabel } from '@mui/material';
import { InputInstance } from './FunctionParameters';
import { FunctionForm } from './FunctionForm';
import { ResponseCard } from './ResponseCard';

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
  console.log('inputInstances', inputInstances);
  return (
    <Accordion key={contractId + functionName}>
      <AccordionSummary expandIcon={<ExpandMoreIcon />}>
        <FormLabel style={{ fontFamily: 'monospace', color: '#00000099' }}>
          {functionName}
        </FormLabel>
      </AccordionSummary>
      <AccordionDetails style={{ paddingTop: 0 }}>
        <FunctionForm
          contractId={contractId}
          functionName={functionName}
          inputInstances={inputInstances}
          setResponse={setResponse}
        />
        <ResponseCard response={response} />
      </AccordionDetails>
    </Accordion>
  );
}
