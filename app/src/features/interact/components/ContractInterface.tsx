import { Copyable, Stack } from '@fuel-ui/react';
import { useContractFunctions } from '../hooks';
import { FunctionInterface } from './FunctionInterface';
import { useState } from 'react';
import { FunctionFragment } from 'fuels/*';

const FUNCTION_COUNT_LIMIT = 1000;
interface ContractInterfaceProps {
  contractId: string;
}

export function ContractInterface({ contractId }: ContractInterfaceProps) {
  // Key: contract.id + functionName
  // Value: API response
  const [responses, setResponses] = useState<Record<string, string>>({});

  const { contract, functionNames } = useContractFunctions(contractId);

  const formattedContractId =
    contractId.slice(0, 6) + '...' + contractId.slice(-5, -1);

  function isType<T>(item: T | undefined): item is T {
    return !!item;
  }

  let functionFragments: FunctionFragment[] = functionNames
    .slice(0, FUNCTION_COUNT_LIMIT)
    .map((functionName) => contract?.interface.functions[functionName])
    .filter(isType<FunctionFragment>);

  let functionInterfaces = functionFragments.map((functionFragment, index) => (
    <div key={`${index}`}>
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
      />
    </div>
  ));

  return (
    <div style={{ padding: '15px' }}>
      <div style={{ padding: '20px 0 20px' }}>
        <div
          style={{
            fontSize: '30px',
            paddingBottom: '10px',
            fontFamily: 'monospace',
          }}>
          Contract Interface
        </div>
        <Copyable value={contractId}>{formattedContractId}</Copyable>
      </div>

      {functionInterfaces}
    </div>
  );
}
