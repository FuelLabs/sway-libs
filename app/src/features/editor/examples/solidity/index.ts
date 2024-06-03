import { ExampleMenuItem } from "../../components/ExampleDropdown";
import { EXAMPLE_SOLIDITY_CONTRACT_COUNTER } from "./counter";
import { EXAMPLE_SOLIDITY_CONTRACT_ERC20 } from "./erc20";
import { EXAMPLE_SOLIDITY_CONTRACT_VOTING } from "./voting";

export const EXAMPLE_SOLIDITY_CONTRACTS: ExampleMenuItem[] = [
    { label: 'Counter.sol', code: EXAMPLE_SOLIDITY_CONTRACT_COUNTER },
    { label: 'ERC20.sol', code: EXAMPLE_SOLIDITY_CONTRACT_ERC20 },
    { label: 'Voting.sol', code: EXAMPLE_SOLIDITY_CONTRACT_VOTING },
  ];
  
