import { useQuery } from "@tanstack/react-query";
import { useContract } from ".";

export function useContractFunctions(contractId: string) {
    const { contract } = useContract(contractId);

    const { data: functions } = useQuery(
        ["contractFunctions"],
        async () => {
            if (!contract) throw new Error("Contract not connected");
            return contract.interface.functions;
        },
        {
            enabled: !!contract,
        }
    );

    return {
        contract: contract,
        functionNames: functions ? [...Object.keys(functions)] : [],
    };
}
