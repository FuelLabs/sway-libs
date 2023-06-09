import { SdkParamType } from '../components/FunctionInterface';
import { ParamTypeLiteral } from '../components/FunctionParameters';

export interface TypeInfo {
  literal: ParamTypeLiteral;
  swayType: string;
}

function getLiteral(sdkType: string): ParamTypeLiteral {
  const [type, name] = sdkType.split(' ');
  switch (type) {
    case 'struct': {
      return name === 'Vec' ? 'vector' : 'object';
    }
    case 'enum': {
      return name === 'Option' ? 'option' : 'enum';
    }
    case 'u8':
    case 'u16':
    case 'u32':
    case 'u64':
      return 'number';
    case 'bool':
      return 'bool';
    case 'b512':
    case 'b256':
    case 'raw untyped ptr':
    default:
      return 'string';
  }
}

function formatTypeArguments({
  type: sdkType,
  typeArguments,
}: SdkParamType): string {
  const [type, name] = sdkType.split(' ');
  if (!name) {
    return type;
  }
  if (!typeArguments?.length) {
    return name;
  }
  return `${name}<${typeArguments.map(formatTypeArguments).join(', ')}>`;
}

export function getTypeInfo(sdkParam: SdkParamType): TypeInfo {
  return {
    literal: getLiteral(sdkParam.type),
    swayType: formatTypeArguments(sdkParam),
  };
}
