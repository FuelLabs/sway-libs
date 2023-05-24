import { toast } from "@fuel-ui/react";
import { useQuery } from "@tanstack/react-query";
import { useFuel } from "./useFuel";

export function useProvider() {
    const [fuel] = useFuel();

    if (!fuel) toast.error("Fuel wallet could not be found");

    const {
        data: provider,
        isLoading,
        isError,
    } = useQuery(
        ["provider"],
        async () => {
            const isConnected = await fuel.isConnected();
            if (!isConnected) {
                return null;
            }
            const fuelProvider = await fuel.getProvider();
            return fuelProvider;
        },
        {
            enabled: !!fuel,
        }
    );

    return { provider, isLoading, isError };
}
