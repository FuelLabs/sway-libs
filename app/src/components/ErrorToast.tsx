import Snackbar from '@mui/base/Snackbar';
import Alert from '@mui/material/Alert';

export interface ErrorToastProps {
  message: string | undefined;
  onClose: () => void;
}

function ErrorToast({ message, onClose }: ErrorToastProps) {
  return (
    <Snackbar open={!!message} autoHideDuration={6000}>
      <Alert
        onClose={onClose}
        severity='error'
        sx={{
          position: 'fixed',
          bottom: '10px',
          right: '10px',
        }}>
        {message}
      </Alert>
    </Snackbar>
  );
}

export default ErrorToast;
