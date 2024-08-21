import { useContractFunctions } from "../hooks/useContractFunctions";
import { FunctionInterface, SdkJsonAbiType } from "./FunctionInterface";
import { useMemo, useState } from "react";
import { CopyableHex } from "../../../components/shared";
import { FunctionFragment } from "fuels";

const FUNCTION_COUNT_LIMIT = 1000;
interface ContractInterfaceProps {
  contractId: string;
  updateLog: (entry: string) => void;
}

export type AbiTypeMap = Map<number, SdkJsonAbiType>;

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

  const typeMap: AbiTypeMap = useMemo(() => {
    console.log("abi types", contract?.interface.jsonAbi);
    return new Map(
      [], // TODO
      // contract?.interface.jsonAbi.types.map((type) => [type.typeId, type]),
    );
  }, [contract]);

  function isType<T>(item: T | undefined): item is T {
    return !!item;
  }

  const functionFragments: FunctionFragment[] = functionNames
    .slice(0, FUNCTION_COUNT_LIMIT)
    .map((functionName) => contract?.interface.functions[functionName])
    .filter(isType<FunctionFragment>);

  const functionInterfaces = useMemo(
    () =>
      functionFragments.map((functionFragment, index) => (
        <div key={`${index}`} style={{ marginBottom: "15px" }}>
          <FunctionInterface
            contractId={contractId}
            typeMap={typeMap}
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
    [contractId, functionFragments, responses, typeMap, updateLog],
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
