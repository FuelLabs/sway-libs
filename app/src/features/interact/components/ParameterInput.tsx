import React from "react";
import { InputInstance, SimpleParamValue } from "./FunctionParameters";
import TextField from "@mui/material/TextField";
import ToggleButton from "@mui/material/ToggleButton";
import ToggleButtonGroup from "@mui/material/ToggleButtonGroup";
import ComplexParameterInput from "./ComplexParameterInput";
import useTheme from "../../../context/theme";
import styled from "@emotion/styled";

export interface ParameterInputProps {
  input: InputInstance;
  value: SimpleParamValue;
  onChange: (value: SimpleParamValue) => void;
}

const StyledTextField = styled(TextField)<{ theme: string }>`
  ${(props) =>
    props.theme === "dark" &&
    `
    & fieldset {
      border: none;
    }
    .MuiInputBase-root {
      border: 1px solid rgba(224, 255, 255, 0.6);
      background-color: transparent;
      color: white;
    }    
  `}
`;

function ParameterInput({ input, value, onChange }: ParameterInputProps) {
  const { theme } = useTheme();

  switch (input.type.literal) {
    case "string":
      return (
        <StyledTextField
          size="small"
          onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
            onChange(event.target.value);
          }}
          theme={theme}
        />
      );
    case "number":
      return (
        <StyledTextField
          size="small"
          type="number"
          onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
            onChange(Number.parseFloat(event.target.value));
          }}
          theme={theme}
        />
      );
    case "bool":
      return (
        <ToggleButtonGroup
          size="small"
          color="primary"
          value={`${!!value}`}
          exclusive
          onChange={() => onChange(!value)}
        >
          <ToggleButton value="true">true</ToggleButton>
          <ToggleButton value="false">false</ToggleButton>
        </ToggleButtonGroup>
      );
    case "vector":
    case "enum":
    case "option":
    case "object":
      return (
        <ComplexParameterInput
          input={input}
          value={value as string}
          onChange={onChange}
        />
      );
  }
}

export default ParameterInput;
