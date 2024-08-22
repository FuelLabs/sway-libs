import { ParamTypeLiteral } from "../components/FunctionParameters";
import { AbiHelper, SdkConcreteType } from "./abi";

/// An interface for displaying ABI types.
export interface TypeInfo {
  literal: ParamTypeLiteral;
  swayType: string;
}

export function getLiteral(sdkType: string): ParamTypeLiteral {
  const [type, name] = sdkType.split(" ");
  const trimmedName = name ? parseTypeName(name) : name;
  switch (type) {
    case "struct": {
      return trimmedName === "Vec" ? "vector" : "object";
    }
    case "enum": {
      return trimmedName === "Option" ? "option" : "enum";
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

export function parseTypeName(typeName: string): string {
  const trimmed = typeName.split("<")[0].split("::");
  return trimmed[trimmed.length - 1];
}

function formatTypeArguments(
  concreteTypeId: string,
  abiHelper: AbiHelper,
): string {
  const sdkType = abiHelper.getConcreteTypeById(concreteTypeId);
  if (!sdkType) {
    return "Unknown";
  }
  const [type, name] = sdkType.type.split(" ");
  if (!name) {
    return type;
  }
  if (!sdkType?.typeArguments?.length) {
    return parseTypeName(name);
  }
  return `${parseTypeName(name)}<${sdkType.typeArguments.map((ta) => formatTypeArguments(ta, abiHelper)).join(", ")}>`;
}

export function getTypeInfo(
  sdkType: SdkConcreteType | undefined,
  abiHelper: AbiHelper,
): TypeInfo {
  if (!abiHelper || !sdkType) {
    return {
      literal: "string",
      swayType: "Unknown",
    };
  }
  return {
    literal: getLiteral(sdkType.type),
    swayType: formatTypeArguments(sdkType.concreteTypeId, abiHelper),
  };
}
