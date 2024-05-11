import React from 'react';
import styled from '@emotion/styled';
import CircularProgress from '@mui/material/CircularProgress';
import Copyable from './Copyable';
import { lightColors, darkColors} from '@fuel-ui/css';
import { useThemeContext } from '../theme/themeContext';

const BorderColor = () => {
  const theme = useThemeContext().theme;
  const borderColor = theme === 'light' ? 'lightgrey' : '#181818';
  return borderColor;
};

export const StyledBorder = styled.div`
  border: 4px solid ${BorderColor}; //change color based on theme
  border-radius: 5px;
`;


export const ButtonSpinner = () => (
  <CircularProgress
    style={{
      margin: '2px',
      height: '14px',
      width: '14px',
      color: lightColors.scalesGreen10,
    }}
  />
);

export const CopyableHex = ({
  hex,
  tooltip,
}: {
  hex: string;
  tooltip: string;
}) => {
  const formattedHex = hex.slice(0, 6) + '...' + hex.slice(-4, hex.length);
  return <Copyable value={hex} label={formattedHex} tooltip={tooltip} />;
};

//dark theme styling for dropdown and input
export const DarkThemeStyling = {
  darkDropdown: {
    '& fieldset': {
      border: 'none',
    },
    '.MuiInputBase-root': {
      bgcolor: darkColors.gray1,
      color: lightColors.scalesGreen7,
      borderBottom: `1px solid ${lightColors.scalesGreen7}`,
      borderRight:`1px solid ${lightColors.scalesGreen7}`,
      '&:hover': {
        background: 'black',
      },
    },
    //color of dropdown label
    '.MuiFormLabel-root': {
      color: '#E0FFFF',
    },
    //color of dropdown svg icon
    '.MuiSvgIcon-root': {
      color: lightColors.scalesGreen7,
    },
  },
  darkInput:{
    '& fieldset': {
      border: 'none',
    },
    '.MuiInputBase-root': {
      border: '1px solid rgba(224, 255, 255, 0.6)',
      bgcolor: 'transparent',
      color: '#E0FFFF',
    },    
  }  
} as const;