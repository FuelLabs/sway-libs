import { cssObj } from '@fuel-ui/css';
import { Flex } from '@fuel-ui/react';
import { FieldValues, UseFormWatch } from 'react-hook-form';
import { FunctionButton } from './FunctionButton';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormGroup from '@mui/material/FormGroup';
import React from 'react';
import { CallType } from '../../../utils/types';
import Switch from '@mui/material/Switch';
import ToggleButtonGroup from '@mui/material/ToggleButtonGroup';
import ToggleButton from '@mui/material/ToggleButton';

interface FunctionButtonsProps {
  // inputInstances: { [k: string]: any }[];
  contractId: string;
  functionName: string;
  // functionValue: {
  //   [key: string]: string;
  // };
  setResponse: (response: string) => void;
  // watch: UseFormWatch<FieldValues>;
}

export function FunctionButtons({
  // inputInstances,
  contractId,
  functionName,
  // functionValue,
  setResponse,
}: // watch,
FunctionButtonsProps) {
  const [dryrun, setDryrun] = React.useState(true);

  return (
    <FormGroup style={{ marginLeft: '15px', marginBottom: '5px' }}>
      <FormControlLabel
        label={
          <div
            style={{
              fontSize: '14px',
              color: '#00000099',
            }}>
            dryrun
          </div>
        }
        control={
          <Switch
            size='small'
            defaultChecked
            onChange={() => setDryrun(!dryrun)}
          />
        }
      />
      <FunctionButton
        // inputInstances={inputInstances}
        contractId={contractId}
        functionName={functionName}
        callType={dryrun ? 'dryrun' : 'call'}
        // functionValue={functionValue}
        setResponse={setResponse}
        // watch={watch}
      />
    </FormGroup>
  );
}
