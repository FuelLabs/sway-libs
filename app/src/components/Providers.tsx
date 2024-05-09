import { globalCss } from '@fuel-ui/css';
import type { ReactNode } from 'react';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from '../utils/queryClient';
import { FuelProvider } from '@fuels/react';
import { defaultConnectors } from '@fuels/connectors';


type ProvidersProps = {
  children: ReactNode;
};

export function Providers({ children }: ProvidersProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <FuelProvider
        fuelConfig={{
          connectors: defaultConnectors(),
        }}>
        {globalCss()()}
        {children}
      </FuelProvider>
    </QueryClientProvider>
  );
}
