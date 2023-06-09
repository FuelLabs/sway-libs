import React from 'react';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import FormLabel from '@mui/material/FormLabel';
import { InputInstance } from './FunctionParameters';
import { FunctionForm } from './FunctionForm';
import { ResponseCard } from './ResponseCard';

export interface FunctionCallAccordionProps {
  contractId: string;
  functionName: string;
  inputInstances: InputInstance[];
  response?: string;
  setResponse: (response: string) => void;
  updateLog: (entry: string) => void;
}

export function FunctionCallAccordion({
  contractId,
  functionName,
  inputInstances,
  response,
  setResponse,
  updateLog,
}: FunctionCallAccordionProps) {
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
          updateLog={updateLog}
        />
        <ResponseCard
          style={{ marginTop: '15px' }}
          response={response ?? 'The response will appear here.'}
        />
      </AccordionDetails>
    </Accordion>
  );
}
