import React from "react";
import Button from "@mui/material/Button";
import Tooltip from "@mui/material/Tooltip";
import useTheme from "../context/theme";

export interface SecondaryButtonProps {
  onClick: () => void;
  text: string;
  endIcon?: React.ReactNode;
  disabled?: boolean;
  tooltip?: string;
  style?: React.CSSProperties;
  header?: boolean;
}
function SecondaryButton({
  onClick,
  text,
  endIcon,
  disabled,
  tooltip,
  style,
  header,
}: SecondaryButtonProps) {
  if (header) {
    style = {
      ...style,
      minWidth: "105px",
      height: "40px",
      marginRight: "15px",
      marginBottom: "10px",
    };
  }

  const { themeColor } = useTheme();

  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            color: themeColor("gray2"),
            borderColor: themeColor("gray2"),
            ":hover": {
              bgcolor: themeColor("sgreen1"),
              borderColor: themeColor("gray2"),
            },
            ":disabled": {
              borderColor: themeColor("disabled1"),
              color: themeColor("disabled1"),
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

export default SecondaryButton;
