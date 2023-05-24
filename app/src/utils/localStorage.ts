const STORAGE_ABI_KEY = "playground_abi";
const STORAGE_BYTECODE_KEY = "playground_bytecode";

export function saveAbi(abi: string) {
    localStorage.setItem(STORAGE_ABI_KEY, abi);
}

export function loadAbi() {
    return localStorage.getItem(STORAGE_ABI_KEY) || "";
}

export function saveBytecode(bytecode: string) {
    localStorage.setItem(STORAGE_BYTECODE_KEY, bytecode);
}

export function loadBytecode() {
    return localStorage.getItem(STORAGE_BYTECODE_KEY) || "";
}
