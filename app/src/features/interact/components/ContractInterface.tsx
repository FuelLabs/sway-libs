import { useContractFunctions } from '../hooks/useContractFunctions';
import { FunctionInterface } from './FunctionInterface';
import { useState } from 'react';
import { FunctionFragment } from 'fuels/*';
import { CopyableHex } from '../../../components/shared';

const FUNCTION_COUNT_LIMIT = 1000;
interface ContractInterfaceProps {
  contractId: string;
  updateLog: (entry: string) => void;
}

export function ContractInterface({
  contractId,
  updateLog,
}: ContractInterfaceProps) {
  // Key: contract.id + functionName
  // Value: API response
  const [responses, setResponses] = useState<Record<string, string>>({});

  const { contract, functionNames } = useContractFunctions(contractId);

  function isType<T>(item: T | undefined): item is T {
    return !!item;
  }

  let functionFragments: FunctionFragment[] = functionNames
    .slice(0, FUNCTION_COUNT_LIMIT)
    .map((functionName) => contract?.interface.functions[functionName])
    .filter(isType<FunctionFragment>);

  let functionInterfaces = functionFragments.map((functionFragment, index) => (
    <div key={`${index}`} style={{ marginBottom: '15px' }}>
      <FunctionInterface
        contractId={contractId}
        functionFragment={functionFragment}
        functionName={functionFragment.name}
        response={responses[contractId + functionFragment.name]}
        setResponse={(response: string) =>
          setResponses({
            ...responses,
            [contractId + functionFragment.name]: response,
          })
        }
        updateLog={updateLog}
      />
    </div>
  ));

  return (
    <div style={{ padding: '15px' }}>
      <div style={{ padding: '20px 0 10px' }}>
        <div
          style={{
            fontSize: '30px',
            paddingBottom: '10px',
            fontFamily: 'monospace',
          }}>
          Contract Interface
        </div>
        <CopyableHex hex={contractId} />
      </div>

      {functionInterfaces}
    </div>
  );
}
