import { FieldValues, UseFormRegister, UseFormSetValue } from 'react-hook-form';
import { isFunctionPrimitive } from '../utils';
import { Stack, Text, Icon, Box } from '@fuel-ui/react';
import { FunctionParameterPrimitive } from './FunctionParameterPrimitive';
import { cssObj } from '@fuel-ui/css';
import Accordion from '@mui/material/Accordion';
import AccordionDetails from '@mui/material/AccordionDetails';
import AccordionSummary from '@mui/material/AccordionSummary/AccordionSummary';

interface FunctionParameterNestedProps {
  name: string;
  input: any;
  index: number;
  register: UseFormRegister<FieldValues>;
  setValue: UseFormSetValue<FieldValues>;
}

export function FunctionParameterNested({
  name,
  input,
  index,
  register,
  setValue,
}: FunctionParameterNestedProps) {
  if (isFunctionPrimitive(input)) {
    return (
      <FunctionParameterPrimitive
        name={name}
        input={input}
        register={register}
        setValue={setValue}
      />
    );
  }

  return (
    // <Stack gap="$1" css={styles.parameters}>
    <Stack gap='$1'>
      <Box css={{ alignSelf: 'center' }}>
        <Text> {input.name} </Text>
      </Box>
      <Accordion style={{ backgroundColor: 'black' }}>
        <AccordionSummary
          expandIcon={<Icon icon='CaretDown' style={{ color: 'white' }} />}
        />
        <AccordionDetails>
          <Stack gap='$5'>
            {input.components.map((field: any, fieldIndex: number) => {
              let fieldName = input.name + index + field.name + fieldIndex;
              return (
                <FunctionParameterNested
                  key={fieldName}
                  name={`${name}.${field.name}`}
                  input={field}
                  index={fieldIndex}
                  register={register}
                  setValue={setValue}
                />
              );
            })}
          </Stack>
        </AccordionDetails>
      </Accordion>
    </Stack>
  );
}

const styles = {
  parameters: cssObj({
    width: '100%',
    alignContent: 'center',
  }),
};
