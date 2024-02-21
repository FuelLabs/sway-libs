import { globalCss } from '@fuel-ui/css';
import type { ReactNode } from 'react';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '../utils/queryClient';
import { FuelProvider } from '@fuel-wallet/react';

type ProvidersProps = {
  children: ReactNode;
};

export function Providers({ children }: ProvidersProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <FuelProvider
          fuelConfig={{
              devMode: true,
            }}
        >
        {globalCss()()}
        {children}
      </FuelProvider>
    </QueryClientProvider>
  );
}
