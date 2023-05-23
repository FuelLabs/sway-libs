import Snackbar from '@mui/base/Snackbar';
import Alert from '@mui/material/Alert';
import React, { useCallback, useEffect } from 'react';

export interface ErrorToastProps {
  open: boolean;
  onClose: () => void;
}

function ErrorToast({ open, onClose }: ErrorToastProps) {
  return (
    <Snackbar
      open={open}
      autoHideDuration={6000}
      //   onClose={() => {
      //     console.log('onClose');
      //     setDismissed(true);
      //   }}
    >
      <Alert
        onClose={onClose}
        severity='error'
        sx={{
          position: 'fixed',
          bottom: '10px',
          left: '10px',
        }}>
        This is an error message!
      </Alert>
    </Snackbar>
  );
}

export default ErrorToast;
