import React from "react";
import Button from "@mui/material/Button";
import Tooltip from "@mui/material/Tooltip";
import { darkColors, lightColors } from "@fuel-ui/css";
import useTheme from "../../../context/theme";

export interface CompileButtonProps {
  onClick: () => void;
  text: string;
  endIcon?: React.ReactNode;
  disabled?: boolean;
  tooltip?: string;
  style?: React.CSSProperties;
}
function CompileButton({
  onClick,
  text,
  endIcon,
  disabled,
  tooltip,
  style,
}: CompileButtonProps) {
  const { themeColor } = useTheme();

  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            height: "40px",
            marginRight: "15px",
            width: "115px",
            marginBottom: "10px",
            background: lightColors.scalesGreen7,
            borderColor: darkColors.gray6,
            color: darkColors.gray6,
            ":hover": {
              color: darkColors.gray6,
              background: lightColors.scalesGreen10,
              borderColor: darkColors.gray6,
            },
            ":disabled": {
              background: themeColor("disabled2"),
              color: themeColor("disabled3"),
            },
          }}
          variant="outlined"
          onClick={onClick}
          disabled={disabled}
          endIcon={endIcon}
        >
          {text}
        </Button>
      </span>
    </Tooltip>
  );
}

export default CompileButton;
