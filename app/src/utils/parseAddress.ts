import { Address } from "fuels";

export function parseAddress(addressInput: string): string | null {
    if (addressInput === "") {
        return null;
    }

    try {
        let parsed = Address.fromString(addressInput);
        return parsed.toHexString();
    } catch {
        return null;
    }
}
