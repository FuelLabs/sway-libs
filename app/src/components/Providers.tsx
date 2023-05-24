import { globalCss } from '@fuel-ui/css';
import { ThemeProvider } from '@fuel-ui/react';
import type { ReactNode } from 'react';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '../utils/queryClient';

type ProvidersProps = {
  children: ReactNode;
};

export function Providers({ children }: ProvidersProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        {globalCss()()}
        {children}
      </ThemeProvider>
    </QueryClientProvider>
  );
}
