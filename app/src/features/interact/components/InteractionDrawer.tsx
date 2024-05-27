import React from 'react';
import Drawer from '@mui/material/Drawer';
import { ContractInterface } from './ContractInterface';
import { useThemeContext } from '../../../context/theme';
import { darkColors, lightColors } from '@fuel-ui/css';

export interface InteractionDrawerProps {
  isOpen: boolean;
  width: string;
  contractId: string;
  updateLog: (entry: string) => void;
}

function InteractionDrawer({
  isOpen,
  width,
  contractId,
  updateLog,
}: InteractionDrawerProps) {

  // Import theme state
  const theme = useThemeContext().theme;
  return (
    <Drawer
      PaperProps={{
        sx: {
          color: theme === 'light' ? darkColors.gray1 : lightColors.scalesGreen7,
          background: theme === 'light' ? '#FFFFFFF': darkColors.gray1,
        },
      }}
      sx={{
        width: width,
        flexShrink: 0,
        '& .MuiDrawer-paper': {
          width: width,
        },
      }}
      variant='persistent'
      anchor='right'
      open={isOpen}>
      <div
        style={{
          width: '100%',
        }}>
        {isOpen && (
          <ContractInterface contractId={contractId} updateLog={updateLog} />
        )}
      </div>
    </Drawer>
  );
}

export default InteractionDrawer;
