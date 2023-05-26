import React from 'react';
import Button from '@mui/material/Button';
import { Tooltip } from '@mui/material';
import { darkColors, lightColors } from '@fuel-ui/css';

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
  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            background: darkColors.green6,
            borderColor: darkColors.green6,
            color: 'white',
            ':hover': {
              color: lightColors.green7,
              background: darkColors.green5,
              borderColor: darkColors.green5,
            },
          }}
          variant='outlined'
          onClick={onClick}
          disabled={disabled}
          endIcon={endIcon}>
          {text}
        </Button>
      </span>
    </Tooltip>
  );
}

export default CompileButton;
