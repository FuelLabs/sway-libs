import { useConnectUI, useWallet } from '@fuel-wallet/react';
import { useCallback, useMemo, useEffect, useRef } from 'react';

export function useConnectIfNotAlready() {
  const connectedCallbackRef = useRef<(() => Promise<void>) | null>(null);
  const failedCallbackRef = useRef<(() => Promise<void>) | null>(null);
  const { connect, isError, isConnecting } = useConnectUI();
  const { wallet } = useWallet();
  const isConnected = useMemo(() => !!wallet, [wallet]);

  const connectIfNotAlready = useCallback(
    (
      connectedCallback: () => Promise<void>,
      failedCallback: () => Promise<void>
    ) => {
      connectedCallbackRef.current = connectedCallback;
      failedCallbackRef.current = failedCallback;

      if (!isConnected && !isConnecting) {
        connect();
      } else {
        connectedCallback();
      }
    },
    [connect, isConnected, isConnecting]
  );

  useEffect(() => {
    if (connectedCallbackRef.current && isConnected) {
      connectedCallbackRef.current();
      connectedCallbackRef.current = null;
    }
  }, [isConnected, connectedCallbackRef]);

  useEffect(() => {
    if (failedCallbackRef.current && isError) {
      failedCallbackRef.current();
      failedCallbackRef.current = null;
    }
  }, [isError, failedCallbackRef]);

  return { connectIfNotAlready, isConnected };
}
