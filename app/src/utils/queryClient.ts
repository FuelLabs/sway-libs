import { QueryClient } from '@tanstack/react-query';
import { displayError } from './error';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      onError: displayError,
      retry: false,
      refetchOnWindowFocus: false,
      structuralSharing: false,
    },
    mutations: {
      onError: displayError,
    },
  },
});
