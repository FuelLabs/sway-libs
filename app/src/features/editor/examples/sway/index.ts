import { ExampleMenuItem } from "../../components/ExampleDropdown";
import { EXAMPLE_SWAY_CONTRACT_COUNTER } from "./counter";
import { EXAMPLE_SWAY_CONTRACT_SRC20 } from "./src20";

export const EXAMPLE_SWAY_CONTRACTS: ExampleMenuItem[] = [
    { label: 'Counter.sw', code: EXAMPLE_SWAY_CONTRACT_COUNTER },
    { label: 'SRC20.sw', code: EXAMPLE_SWAY_CONTRACT_SRC20 },
  ];
  