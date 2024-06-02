import React from 'react';
import Drawer from '@mui/material/Drawer';
import { ContractInterface } from './ContractInterface';
import useTheme from '../../../context/theme';

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

  const { themeColor } = useTheme();
  return (
    <Drawer
      PaperProps={{
        sx: {
          color: themeColor('black1'),
          background: themeColor('white2'),
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
