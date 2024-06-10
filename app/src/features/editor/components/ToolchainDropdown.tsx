import React from "react";
import Tooltip from "@mui/material/Tooltip";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import InputLabel from "@mui/material/InputLabel/InputLabel";
import useTheme from "../../../context/theme";
import styled from "@emotion/styled";
import { lightColors, darkColors } from "@fuel-ui/css";

const ToolchainNames = [
  "testnet",
  "beta-5",
  "beta-4",
  "beta-3",
  "beta-2",
  "beta-1",
  "latest",
  "nightly",
] as const;
export type Toolchain = (typeof ToolchainNames)[number];

export function isToolchain(value: string | null): value is Toolchain {
  const found = ToolchainNames.find((name) => name === value);
  return !!value && found !== undefined;
}

export interface ToolchainDropdownProps {
  toolchain: Toolchain;
  setToolchain: (toolchain: Toolchain) => void;
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

function ToolchainDropdown({
  toolchain,
  setToolchain,
  style,
}: ToolchainDropdownProps) {
  const { themeColor, theme } = useTheme();

  return (
    <StyledFormControl style={{ ...style }} size="small" theme={theme}>
      <InputLabel id="toolchain-select-label">Toolchain</InputLabel>
      <Tooltip placement="top" title={"Fuel toolchain to use for compilation"}>
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
            id="toolchain-select"
            labelId="toolchain-select-label"
            label="Toolchain"
            style={{ minWidth: "70px" }}
            variant="outlined"
            value={toolchain}
            onChange={(event) => setToolchain(event.target.value as Toolchain)}
          >
            {ToolchainNames.map((toolchain) => (
              <MenuItem key={toolchain} value={toolchain}>
                {toolchain}
              </MenuItem>
            ))}
          </Select>
        </span>
      </Tooltip>
    </StyledFormControl>
  );
}

export default ToolchainDropdown;
