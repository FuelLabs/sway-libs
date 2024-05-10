import React, {useContext} from 'react';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import { darkColors, lightColors } from '@fuel-ui/css';
import { ThemeContext } from '../theme/themeContext';

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
      minWidth: '105px',
      height: '40px',
      marginRight: '15px',
      marginBottom: '10px',
    };
  }

  // Import theme state
  const theme = useContext(ThemeContext)?.theme;

  return (
    <Tooltip title={tooltip}>
      <span>
        <Button
          sx={{
            ...style,
            color: theme === 'light' ? darkColors.gray6 : lightColors.scalesGreen7,
            bgcolor: theme === 'light' ? '': '#1F1F1F',
            borderColor: darkColors.gray6,
            ':hover': {
              bgcolor: theme === 'light' ? lightColors.scalesGreen3 : darkColors.gray7,
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
