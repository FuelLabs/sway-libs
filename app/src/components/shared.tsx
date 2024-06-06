import styled from "@emotion/styled";
import CircularProgress from "@mui/material/CircularProgress";
import Copyable from "./Copyable";
import { lightColors, darkColors } from "@fuel-ui/css";
import useTheme from "../context/theme";

const BorderColor = () => {
  const { themeColor } = useTheme();
  const borderColor = themeColor("gray6");
  return borderColor;
};

export const StyledBorder = styled.div`
  border: 4px solid ${BorderColor}; //change color based on theme
  border-radius: 5px;
`;

export const ButtonSpinner = () => (
  <CircularProgress
    style={{
      margin: "2px",
      height: "14px",
      width: "14px",
      color: lightColors.scalesGreen10,
    }}
  />
);

export const CopyableHex = ({
  hex,
  tooltip,
}: {
  hex: string;
  tooltip: string;
}) => {
  const formattedHex = hex.slice(0, 6) + "..." + hex.slice(-4, hex.length);
  return <Copyable value={hex} label={formattedHex} tooltip={tooltip} />;
};

//dark theme styling for dropdown and input
export const DarkThemeStyling = {
  darkDropdown: {
    "& fieldset": {
      border: "none",
    },
    ".MuiInputBase-root": {
      bgcolor: darkColors.gray1,
      color: lightColors.gray1,
      outline: `1px solid ${darkColors.gray8}`,
      "&:hover": {
        background: "transparent",
      },
    },
    //color of dropdown label
    ".MuiFormLabel-root": {
      color: "white",
    },
    //color of dropdown svg icon
    ".MuiSvgIcon-root": {
      color: lightColors.gray8,
    },
  },
  darkInput: {
    "& fieldset": {
      border: "none",
    },
    ".MuiInputBase-root": {
      border: "1px solid rgba(224, 255, 255, 0.6)",
      bgcolor: "transparent",
      color: "white",
    },
  },
  darkAccordion: {
    background: darkColors.scalesGray1,
    border: `1px solid ${darkColors.gray6}`,
  },
} as const;
