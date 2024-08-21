import { JsonAbi } from "fuels";
import { ParamTypeLiteral } from "../components/FunctionParameters";

/// Types ported from the fuels SDK
export interface SdkConcreteType {
  readonly type: string;
  readonly concreteTypeId: string;
  readonly metadataTypeId?: number;
  readonly typeArguments?: readonly string[];
}
export interface SdkMetadataType {
  readonly type: string;
  readonly metadataTypeId: number;
  readonly components?: readonly SdkComponent[];
  readonly typeParameters?: readonly number[];
}

export interface SdkComponent extends SdkTypeArgument {
  readonly name: string;
}

export interface SdkTypeArgument {
  readonly typeId: number | string;
  readonly typeArguments?: readonly SdkTypeArgument[];
}

/// This is a helper class for ABI related functions.
export class AbiHelper {
  /// A map of all the concrete types in the ABI indexed by the concrete type ID (hash).
  concreteTypeMap: Map<string, SdkConcreteType>;

  /// A map of all the metadata types in the ABI indexed by the metadata type ID (index).
  metadataTypeMap: Map<number, SdkMetadataType>;

  constructor(jsonAbi: JsonAbi | undefined) {
    this.concreteTypeMap = new Map();
    this.metadataTypeMap = new Map();

    jsonAbi?.concreteTypes?.forEach((concreteType: SdkConcreteType) => {
      this.concreteTypeMap.set(concreteType.concreteTypeId, concreteType);
    });

    jsonAbi?.metadataTypes?.forEach(
      (metadataType: SdkMetadataType, index: number) => {
        this.metadataTypeMap.set(index, metadataType);
      },
    );
  }

  getConcreteTypeById(id?: string): SdkConcreteType | undefined {
    return id ? this.concreteTypeMap.get(id) : undefined;
  }

  getMetadataTypeById(id?: number): SdkMetadataType | undefined {
    return id ? this.metadataTypeMap.get(id) : undefined;
  }

  getTypesById(id: string | number | undefined): {
    concreteType: SdkConcreteType | undefined;
    metadataType: SdkMetadataType | undefined;
  } {
    if (typeof id === "number") {
      const metadataType = this.getMetadataTypeById(id);
      return { concreteType: undefined, metadataType };
    } else {
      const concreteType = this.getConcreteTypeById(id);
      const metadataType = concreteType
        ? this.getMetadataTypeById(concreteType.metadataTypeId)
        : undefined;
      return { concreteType, metadataType };
    }
  }
}
