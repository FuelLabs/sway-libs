import { EditorLanguage } from "../components/ActionOverlay";
import { ExampleMenuItem } from "../components/ExampleDropdown";
import { EXAMPLE_SOLIDITY_CONTRACTS } from "./solidity";
import { EXAMPLE_SWAY_CONTRACTS } from "./sway";

export const EXAMPLE_CONTRACTS: Record<EditorLanguage, ExampleMenuItem[]> = {
    sway: EXAMPLE_SWAY_CONTRACTS,
    solidity: EXAMPLE_SOLIDITY_CONTRACTS,
  };
  