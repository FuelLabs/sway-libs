import React from 'react';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import { darkColors, lightColors } from '@fuel-ui/css';

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
  if (!!header) {
    style = {
      ...style,
      minWidth: '115px',
      height: '40px',
      marginRight: '15px',
      marginBottom: '10px',
    };
  }
  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            color: darkColors.gray6,
            borderColor: darkColors.gray6,
            ':hover': {
              bgcolor: lightColors.scalesGreen3,
              borderColor: darkColors.gray6,
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
