import { useContractFunctions } from '../hooks/useContractFunctions';
import {
  FunctionInterface,
  SdkComponent,
  SdkConcreteType,
  SdkJsonAbiArgument,
  SdkJsonAbiType,
  SdkMetadataType,
} from './FunctionInterface';
import { useMemo, useState } from 'react';
import { CopyableHex } from '../../../components/shared';
import { FunctionFragment } from 'fuels';
import { get } from 'http';

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
    {}
  );

  const { contract, functionNames } = useContractFunctions(contractId);

  const typeMap: AbiTypeMap = useMemo(() => {
    const map = new Map<number, SdkJsonAbiType>();
    const jsonAbi = contract?.interface.jsonAbi;
    if (!jsonAbi) {
      return map;
    }
    const offset = jsonAbi.concreteTypes.length;

    console.log('abi types', jsonAbi);

    const findTypeAndIndex = (
      typeId: number | string
    ): { type: SdkConcreteType | SdkMetadataType; index: number } => {
      if (typeof typeId === 'string') {
        let index = jsonAbi.concreteTypes.findIndex(
          (type) => type.type === typeId
        );
        let type = jsonAbi.concreteTypes[index];
        return {
          type,
          index,
        };
      } else {
        let type = jsonAbi.metadataTypes[typeId];
        return {
          type,
          index: typeId + offset,
        };
      }
    };

    const getComponents = (components: SdkComponent[] | undefined): SdkJsonAbiArgument[] | null => {
      if (!components) {
        return null;
      }

      return components.map((component) => {
        const { type: componentType, index } = findTypeAndIndex(component.typeId);

        return {
          type: index,
          name: componentType?.type ?? '',       
          typeArguments: null, // TODO
        };
      });
    };

    const getTypeArguments = (sdkType: SdkConcreteType | SdkMetadataType | undefined): SdkJsonAbiArgument[] | null => {
      if (!sdkType) {
        return null;
      }
      if ("typeArguments" in sdkType) {
        return sdkType.typeArguments?.map((typeArgument) => {
          let index = jsonAbi.concreteTypes.findIndex(
            (type) => type?.type === typeArgument
          );
          let concreteType = jsonAbi.concreteTypes[index];
          return {
            type: index,
            name: concreteType?.type ?? '',
            typeArguments: getTypeArguments(concreteType)
          };
        }) ?? null;
      } else if ("typeParameters" in sdkType) {
        return sdkType.typeParameters?.map((typeParameter) => {
          let metadataType = jsonAbi.metadataTypes[typeParameter];
          return {
            type: typeParameter + offset,
            name: metadataType?.type ?? '',
            typeArguments: getTypeArguments(metadataType)
          };
        }) ?? null;
      }
      return null;
    };

    // Add concrete types
    contract?.interface.jsonAbi.concreteTypes.map((concreteType, idx) => {
      let metadataType = concreteType.metadataTypeId
        ? jsonAbi.metadataTypes[concreteType.metadataTypeId]
        : null;

      // let components =
      //   metadataType?.components?.map((component) => {
      //     const { type: componentType, index } = findTypeAndIndex(component.typeId);

      //     return {
      //       typeId: index,
      //       type: componentType.type,
      //       components: null, // TODO
      //       typeArguments: null, // TODO
      //     };
      //   }) ?? null;

      // let typeArguments =
      //   concreteType.typeArguments?.map((typeArgument) => {
      //     return 0; // TODO
      //   }) ?? null;

      let sdkComponents = metadataType?.components?.map(meta => meta as SdkComponent);
      map.set(idx, {
        typeId: idx,
        type: concreteType.type,
        components: getComponents(sdkComponents),
        typeArguments: getTypeArguments(concreteType)?.map(arg => arg.type) ?? null,
      });
    });

    // Add remaining metadata types
    // metadataTypesToInsert.map((type, idx) => {
    //   map.set(idx, {
    //     typeId: idx,
    //     type: type.type,
    //     components: null,
    //     typeArguments: null,
    //   });
    // });

    // Insert components

    // Insert type arguments

    // return new Map(
    //   [] // TODO
    //   // contract?.interface.jsonAbi.types.map((type) => [type.typeId, type]),
    // );

    console.log('map', map)
    return map;
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
        <div key={`${index}`} style={{ marginBottom: '15px' }}>
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
    [contractId, functionFragments, responses, typeMap, updateLog]
  );

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
        <CopyableHex hex={contractId} tooltip='contract ID' />
      </div>

      {functionInterfaces}
    </div>
  );
}
