import { toast } from "@fuel-ui/react";

export function panicError(msg: string) {
    <div>Unexpected block execution error: {msg}</div>;
};

export function displayError(error: any) {
    const msg = error?.message || error;
    toast.error(msg?.includes("Panic") ? panicError(msg) : msg, {
        duration: 100000000,
        id: msg,
    });
}
