import React from 'react';
import Button from '@mui/material/Button';
import { Tooltip } from '@mui/material';
import { darkColors, lightColors } from '@fuel-ui/css';

export interface SecondaryButtonProps {
  onClick: () => void;
  text: string;
  endIcon?: React.ReactNode;
  disabled?: boolean;
  tooltip?: string;
  style?: React.CSSProperties;
}
function SecondaryButton({
  onClick,
  text,
  endIcon,
  disabled,
  tooltip,
  style,
}: SecondaryButtonProps) {
  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            color: darkColors.green5,
            borderColor: darkColors.green5,
            ':hover': {
              bgcolor: lightColors.green2,
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

export default SecondaryButton;
