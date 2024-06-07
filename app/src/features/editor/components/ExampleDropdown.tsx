import React, { useCallback } from "react";
import Tooltip from "@mui/material/Tooltip";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl/FormControl";
import Select, { SelectChangeEvent } from "@mui/material/Select/Select";
import InputLabel from "@mui/material/InputLabel/InputLabel";
import useTheme from "../../../context/theme";
import styled from "@emotion/styled";
import { lightColors, darkColors } from "@fuel-ui/css";

export interface ExampleMenuItem {
  label: string;
  code: string;
}

export interface ExampleDropdownProps {
  handleSelect: (example: string) => void;
  examples: ExampleMenuItem[];
  style?: React.CSSProperties;
}

const StyledFormControl = styled(FormControl)<{ theme: string }>`
  ${(props) =>
    props.theme === "dark" &&
    `
    & fieldset {
      border: none;
    }
    .MuiInputBase-root {
      background-color: ${darkColors.gray1};
      color: ${lightColors.gray1};
      outline: 1px solid ${darkColors.gray8};
      &:hover {
        background: transparent;
      }
    }
    .MuiFormLabel-root {
      color: white;
    }
    .MuiSvgIcon-root {
      color: ${lightColors.gray8};
    }
  `}
`;

function ExampleDropdown({
  handleSelect,
  examples,
  style,
}: ExampleDropdownProps) {
  const [currentExample, setCurrentExample] = React.useState<ExampleMenuItem>({
    label: "",
    code: "",
  });

  const onChange = useCallback(
    (event: SelectChangeEvent<string>) => {
      const index = event.target.value as unknown as number;
      const example = examples[index];
      if (example) {
        setCurrentExample(example);
        handleSelect(example.code);
      }
    },
    [handleSelect, setCurrentExample, examples],
  );

  const { themeColor, theme } = useTheme();

  return (
    <StyledFormControl style={{ ...style }} size="small" theme={theme}>
      <InputLabel id="example-select-label">Example</InputLabel>
      <Tooltip placement="top" title={"Load an example contract"}>
        <span>
          <Select
            MenuProps={{
              PaperProps: {
                style: {
                  background: themeColor("white2"),
                  color: themeColor("gray3"),
                },
              },
            }}
            id="example-select"
            labelId="example-select-label"
            label="Example"
            variant="outlined"
            style={{ minWidth: "110px" }}
            value={currentExample.label}
            onChange={onChange}
          >
            {examples.map(({ label }: ExampleMenuItem, index) => (
              <MenuItem key={`${label}-${index}`} value={index}>
                {label}
              </MenuItem>
            ))}
          </Select>
        </span>
      </Tooltip>
    </StyledFormControl>
  );
}

export default ExampleDropdown;
