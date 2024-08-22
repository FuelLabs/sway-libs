import { useContractFunctions } from "../hooks/useContractFunctions";
import { FunctionInterface } from "./FunctionInterface";
import { AbiHelper } from "../utils/abi";
import { useMemo, useState } from "react";
import { CopyableHex } from "../../../components/shared";
import { FunctionFragment } from "fuels";

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
  const [responses, setResponses] = useState<Record<string, string | Error>>(
    {},
  );

  const { contract, functionNames } = useContractFunctions(contractId);

  function isType<T>(item: T | undefined): item is T {
    return !!item;
  }

  const functionFragments: FunctionFragment[] = functionNames
    .slice(0, FUNCTION_COUNT_LIMIT)
    .map((functionName) => contract?.interface.functions[functionName])
    .filter(isType<FunctionFragment>);

  const abiHelper = useMemo(() => {
    return new AbiHelper(contract?.interface?.jsonAbi);
  }, [contract]);

  const functionInterfaces = useMemo(
    () =>
      functionFragments.map((functionFragment, index) => (
        <div key={`${index}`} style={{ marginBottom: "15px" }}>
          <FunctionInterface
            contractId={contractId}
            abiHelper={abiHelper}
            functionFragment={functionFragment}
            functionName={functionFragment.name}
            response={responses[contractId + functionFragment.name]}
            setResponse={(response: string | Error) =>
              setResponses({
                ...responses,
                [contractId + functionFragment.name]: response,
              })
            }
            updateLog={updateLog}
          />
        </div>
      )),
    [contractId, functionFragments, responses, abiHelper, updateLog],
  );

  return (
    <div style={{ padding: "15px" }}>
      <div style={{ padding: "20px 0 10px" }}>
        <div
          style={{
            fontSize: "30px",
            paddingBottom: "10px",
            fontFamily: "monospace",
          }}
        >
          Contract Interface
        </div>
        <CopyableHex hex={contractId} tooltip="contract ID" />
      </div>

      {functionInterfaces}
    </div>
  );
}
