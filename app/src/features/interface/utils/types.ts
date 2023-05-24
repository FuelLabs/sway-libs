import { bn } from 'fuels';
import { ParamType } from '../components/FunctionParameters';

export interface InstantiableType {
  type: ParamType;
  create:
    | typeof bn
    | NumberConstructor
    | BooleanConstructor
    | StringConstructor;
}

export function getInstantiableType(type: string): InstantiableType {
  switch (type) {
    case 'u8':
    case 'u16':
    case 'u32':
      return {
        type: 'number',
        create: Number,
      };
    case 'u64':
      return {
        type: 'number',
        create: bn,
      };
    case 'bool':
      return {
        type: 'bool',
        create: Boolean,
      };
    case 'b512':
    case 'b256':
    case 'raw untyped ptr':
      return {
        type: 'text',
        create: String,
      };
    default:
      return {
        type: 'string',
        create: String,
      };
  }
}
