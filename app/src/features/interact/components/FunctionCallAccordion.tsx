import React, {useContext} from 'react';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AccordionDetails from '@mui/material/AccordionDetails';
import FormLabel from '@mui/material/FormLabel';
import { InputInstance, ParamTypeLiteral } from './FunctionParameters';
import { FunctionForm } from './FunctionForm';
import { ResponseCard } from './ResponseCard';
import { darkColors ,lightColors} from '@fuel-ui/css';
import { ThemeContext } from '../../../theme/themeContext';

export interface FunctionCallAccordionProps {
  contractId: string;
  functionName: string;
  inputInstances: InputInstance[];
  outputType?: ParamTypeLiteral;
  response?: string | Error;
  setResponse: (response: string | Error) => void;
  updateLog: (entry: string) => void;
}

export function FunctionCallAccordion({
  contractId,
  functionName,
  inputInstances,
  outputType,
  response,
  setResponse,
  updateLog,
}: FunctionCallAccordionProps) {
  // Import theme state
  const theme = useContext(ThemeContext)?.theme;

  return (
    <Accordion key={contractId + functionName} sx={[theme !== 'light' && {background: '#181818', border: `1px solid ${darkColors.gray6}`}]}>
      <AccordionSummary expandIcon={<ExpandMoreIcon sx={[theme !== 'light' && {color: lightColors.scalesGreen7}]} />}>
        <FormLabel style={{ fontFamily: 'monospace', color: theme === 'light' ? '#00000099' : lightColors.scalesGreen3 }}>
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
          outputType={outputType}
          response={response}
        />
      </AccordionDetails>
    </Accordion>
  );
}
