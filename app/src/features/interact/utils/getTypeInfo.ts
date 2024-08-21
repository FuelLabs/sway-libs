import { AbiTypeMap } from "../components/ContractInterface";
import { SdkJsonAbiType } from "../components/FunctionInterface";
import { ParamTypeLiteral } from "../components/FunctionParameters";

export interface TypeInfo {
  literal: ParamTypeLiteral;
  swayType: string;
}

function getLiteral(sdkType: string): ParamTypeLiteral {
  const [type, name] = sdkType.split(" ");
  switch (type) {
    case "struct": {
      return name === "Vec" ? "vector" : "object";
    }
    case "enum": {
      return name === "Option" ? "option" : "enum";
    }
    case "u8":
    case "u16":
    case "u32":
    case "u64":
      return "number";
    case "bool":
      return "bool";
    case "b512":
    case "b256":
    case "raw untyped ptr":
    default:
      return "string";
  }
}

function formatTypeArguments(
  sdkArgumentTypeId: number,
  typeMap: AbiTypeMap,
): string {
  const sdkType = typeMap.get(sdkArgumentTypeId);
  if (!sdkType) {
    return "Unknown";
  }
  const [type, name] = sdkType.type.split(" ");
  if (!name) {
    return type;
  }
  if (!sdkType?.typeArguments?.length) {
    return name;
  }
  return `${name}<${sdkType.typeArguments.map((ta) => formatTypeArguments(ta, typeMap)).join(", ")}>`;
}

export function getTypeInfo(
  sdkType: SdkJsonAbiType,
  typeMap: AbiTypeMap,
): TypeInfo {
  if (!typeMap) {
    return {
      literal: "string",
      swayType: "Unknown",
    };
  }
  return {
    literal: getLiteral(sdkType.type),
    swayType: formatTypeArguments(sdkType.typeId, typeMap),
  };
}
