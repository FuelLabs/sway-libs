import React from 'react';
import { darkColors } from '@fuel-ui/css';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';

export interface CopyableProps {
  value: string;
  label: string;
}

async function handleCopy(value: string) {
  await navigator.clipboard.writeText(value);
}

function Copyable({ value, label }: CopyableProps) {
  return (
    <div style={{ color: darkColors.gray6 }}>
      {label}
      <Tooltip title='Click to copy'>
        <IconButton
          disableRipple
          onClick={() => handleCopy(value)}
          aria-label='copy'>
          <ContentCopyIcon style={{ fontSize: '14px' }} />
        </IconButton>
      </Tooltip>
    </div>
  );
}

export default Copyable;
