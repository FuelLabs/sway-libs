import { SimpleParamType } from '../components/FunctionParameters';

const STRUCT_PREFIX = 'struct ';

export interface TypeInfo {
  simpleType: SimpleParamType;
  swayType: string;
}

// TODO: support Vectors!
export function getTypeInfo(type: string): TypeInfo {
  console.log('getTypeInfo', type);

  if (type.startsWith(STRUCT_PREFIX)) {
    return {
      simpleType: 'object',
      swayType: type.split(STRUCT_PREFIX)[1],
    };
  }

  switch (type) {
    case 'u8':
    case 'u16':
    case 'u32':
    case 'u64':
      return {
        simpleType: 'number',
        swayType: type,
      };

    case 'bool':
      return {
        simpleType: 'bool',
        swayType: type,
      };
    case 'b512':
    case 'b256':
    case 'raw untyped ptr':
    default:
      return {
        simpleType: 'string',
        swayType: type,
      };
  }
}
