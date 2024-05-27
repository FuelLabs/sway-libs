import React from "react";
import { darkColors } from '@fuel-ui/css';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { useThemeContext } from "../context/theme";

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
  // Import theme state
  const theme = useThemeContext().theme;

  return (
    <div
      style={{ cursor: 'pointer', color: theme === "light" ? darkColors.gray6 : "#FFFFFF", }}
      onClick={() => handleCopy(value)}>
      <Tooltip title={`Click to copy ${tooltip}`}>
        <span>
          {href ? (<a href={value} target='_blank' rel='noreferrer'>{label}</a>) : (<span style={{ padding: '8px 0 8px' }}>{label}</span>)}
          <IconButton disableRipple aria-label='copy'>
            <ContentCopyIcon style={{ fontSize: '14px', color: theme === "light" ? "" : darkColors.accent10, }} />
          </IconButton>
        </span>
      </Tooltip>
    </div>
  );
}

export default Copyable;
