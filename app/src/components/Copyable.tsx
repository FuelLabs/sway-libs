import React from 'react';
import { darkColors } from '@fuel-ui/css';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';

export interface CopyableProps {
  value: string;
  label: string;
  tooltip: string;
}

async function handleCopy(value: string) {
  await navigator.clipboard.writeText(value);
}

function Copyable({ value, label, tooltip }: CopyableProps) {
  return (
    <div
      style={{ cursor: 'pointer', color: darkColors.gray6 }}
      onClick={() => handleCopy(value)}>
      <Tooltip title={`Click to copy ${tooltip}`}>
        <span>
          <span style={{ padding: '8px 0 8px' }}>{label}</span>
          <IconButton disableRipple aria-label='copy'>
            <ContentCopyIcon style={{ fontSize: '14px' }} />
          </IconButton>
        </span>
      </Tooltip>
    </div>
  );
}

export default Copyable;
