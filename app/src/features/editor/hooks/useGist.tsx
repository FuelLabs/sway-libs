import { useState, useEffect, useCallback } from 'react';
import { SERVER_URI } from '../../../constants';
import { track } from '@vercel/analytics/react';
import { EditorLanguage } from '../components/ActionOverlay';
import { useSearchParams } from 'react-router-dom';

interface GistMeta {
  url: string;
  id: string;
}

interface ContractCode {
  contract: string;
  language: EditorLanguage;
}

interface GistResponse {
  gist: GistMeta;
  swayContract: string;
  transpileContract: ContractCode;
  error?: string;
}

export function useGist(
  onSwayCodeChange: (swayCode: string) => void,
  onSolidityCodeChange: (solidityCode: string) => void
): {
  newGist: (
    swayContract: string,
    transpileContract: ContractCode
  ) => Promise<GistMeta | undefined>;
} {
  // The search parameters for the current URL.
  const [searchParams] = useSearchParams();
  const [gist, setGist] = useState<GistResponse | null>(null);

  useEffect(() => {
    const gist_id = searchParams.get('gist');
    if (!!gist_id) {
      const request = new Request(`${SERVER_URI}/gist/${gist_id}`, {
        method: 'GET',
      });

      fetch(request)
        .then((response) => {
          if (response.status < 400) {
            return response.json();
          } else {
            track('Get Gist Error', {
              source: 'network',
              status: response.status,
            });
          }
        })
        .then((response: GistResponse) => {
          const { error } = response;
          if (error) {
            track('Get Gist Error', { source: 'server' });
          } else {
            setGist(response);
          }
        })
        .catch(() => {
          track('Get Gist Error', { source: 'network' });
        });
    }
  }, [searchParams, setGist]);

  // Update the editor code when the gist is loaded.
  useEffect(() => {
    if (!!gist) {
      onSwayCodeChange(gist.swayContract);
      onSolidityCodeChange(gist.transpileContract.contract);
    }
  }, [gist, onSwayCodeChange, onSolidityCodeChange]);

  const newGist = useCallback(
    async (sway_contract: string, transpile_contract: ContractCode) => {
      const request = new Request(`${SERVER_URI}/gist`, {
        method: 'POST',
        body: JSON.stringify({
          sway_contract,
          transpile_contract,
        }),
      });

      const res = await fetch(request)
        .then((response) => {
          if (response.status < 400) {
            return response.json();
          } else {
            track('New Gist Error', {
              source: 'network',
              status: response.status,
            });
          }
        })
        .then((response: { gist: GistMeta; error: string | undefined }) => {
          const { error, gist } = response;
          if (error) {
            track('New Gist Error', { source: 'server' });
          } else {
            return gist;
          }
        })
        .catch(() => {
          track('New Gist Error', { source: 'network' });
        });

      return res ?? undefined;
    },
    []
  );

  return { newGist };
}
