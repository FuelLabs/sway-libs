import { cssObj } from '@fuel-ui/css';
import { Box, Stack, Text, Input, Checkbox } from '@fuel-ui/react';
import { FieldValues, UseFormRegister, UseFormSetValue } from 'react-hook-form';

interface FunctionParameterPrimitiveProps {
  name: string;
  input: any;
  register: UseFormRegister<FieldValues>;
  setValue: UseFormSetValue<FieldValues>;
}

export function FunctionParameterPrimitive({
  name,
  input,
  register,
  setValue,
}: FunctionParameterPrimitiveProps) {
  return (
    // <Stack gap='$1' css={styles.flex}>
    <Stack gap='$1'>
      {/* <Box css={styles.box}> */}
      <Box>
        <Text> {input.name} </Text>
      </Box>
      {input.type.type === 'number' && (
        // <Input css={styles.number}>
        <Input>
          <Input.Field
            id={input.name}
            type={input.type.type}
            {...register(name, { required: true })}
          />
        </Input>
      )}
      {input.type.type === 'bool' && (
        // <Input css={styles.checkbox}>
        <Input>
          <Checkbox
            id={input.name}
            defaultChecked={false}
            onCheckedChange={(e) => {
              setValue(name, e as boolean);
            }}
            {...register(name, { required: true })}
          />
        </Input>
      )}
    </Stack>
  );
}

const styles = {
  flex: cssObj({
    alignSelf: 'center',
  }),
  box: cssObj({
    alignSelf: 'center',
  }),
  number: cssObj({
    width: 'min-content',
    alignSelf: 'center',
  }),
  checkbox: cssObj({
    height: 'min-content',
    width: 'min-content',
    alignSelf: 'center',
  }),
};
