import React from "react";
import { darkColors } from "@fuel-ui/css";
import IconButton from "@mui/material/IconButton";
import Tooltip from "@mui/material/Tooltip";
import ContentCopyIcon from "@mui/icons-material/ContentCopy";
import useTheme from "../context/theme";

export interface CopyableProps {
  value: string;
  label: string;
  tooltip: string;
  href?: boolean;
}

async function handleCopy(value: string) {
  await navigator.clipboard.writeText(value);
}

function Copyable({ value, label, tooltip, href }: CopyableProps) {
  const { themeColor } = useTheme();

  return (
    <div
      style={{ cursor: "pointer", color: themeColor("gray1") }}
      onClick={() => handleCopy(value)}
    >
      <Tooltip title={`Click to copy ${tooltip}`}>
        <span>
          {href ? (
            <a
              href={value}
              target="_blank"
              rel="noreferrer"
              style={{ color: themeColor("gray3") }}
            >
              {label}
            </a>
          ) : (
            <span style={{ padding: "8px 0 8px" }}>{label}</span>
          )}
          <IconButton disableRipple aria-label="copy">
            <ContentCopyIcon
              style={{ fontSize: "14px", color: darkColors.gray9 }}
            />
          </IconButton>
        </span>
      </Tooltip>
    </div>
  );
}

export default Copyable;
