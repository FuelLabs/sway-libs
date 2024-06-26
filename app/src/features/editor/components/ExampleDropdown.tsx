import React, { useCallback } from "react";
import Tooltip from "@mui/material/Tooltip";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl/FormControl";
import Select, { SelectChangeEvent } from "@mui/material/Select/Select";
import InputLabel from "@mui/material/InputLabel/InputLabel";

export interface ExampleMenuItem {
  label: string;
  code: string;
}

export interface ExampleDropdownProps {
  handleSelect: (example: string) => void;
  examples: ExampleMenuItem[];
  style?: React.CSSProperties;
}

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

  return (
    <FormControl style={{ ...style }} size="small">
      <InputLabel id="example-select-label">Example</InputLabel>
      <Tooltip placement="top" title={"Load an example contract"}>
        <span>
          <Select
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
    </FormControl>
  );
}

export default ExampleDropdown;
