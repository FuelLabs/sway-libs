export const EXAMPLE_SOLIDITY_CONTRACT_COUNTER = `// no support for delegatecall, this, strings & ASM blocks.
pragma solidity ^0.8.24;

contract Counter {
    uint64 count;

    function get() public view returns (uint64) {
        return count;
    }

    function increment() public {
        count += 1;
    }
}`;