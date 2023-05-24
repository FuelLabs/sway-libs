import { Box, Stack } from '@fuel-ui/react';
import { useContractFunctions } from '../hooks';
import { FunctionInterface } from './FunctionInterface';
import { cssObj } from '@fuel-ui/css';
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

  // let functionInterfaces: JSX.Element[] = functionNames
  //   .slice(0, FUNCTION_COUNT_LIMIT)
  //   .map((functionName) =>
  //     FunctionInterface({
  //       contractId,
  //       functionFragment: contract?.interface.functions[functionName],
  //       response: responses[contractId + functionName],
  //       setResponse: (response: string) =>
  //         setResponses({
  //           ...responses,
  //           [contractId + functionName]: response,
  //         }),
  //     })
  //   );

  return (
    <div key={contractId} style={{ marginLeft: '15px', width: '95%' }}>
      {contract && <Stack gap='$7'>{functionInterfaces}</Stack>}
    </div>
  );
}
