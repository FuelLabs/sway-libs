export const EXAMPLE_SOLIDITY_CONTRACT_VOTING = `pragma solidity ^0.8.24;

contract Voting {
    uint64 public numVoters;
    mapping(bytes32 => uint256) public votes;
    mapping(address =>  mapping(bytes32 => bool)) public hasVoted;
    mapping(address => bool) public voters;
    
    constructor(address[] memory voters_) public {
        for (numVoters = 0; numVoters < voters_.length; numVoters++) {
            voters[voters_[numVoters]] = true;
        }
    }
    
    function vote(bytes32 topic) public returns (bool) {
        require(voters[msg.sender], "is-voter");
        require(hasVoted[msg.sender][topic] == false, "has-voted");
        
        votes[topic] += 1;
        hasVoted[msg.sender][topic] = true;

        return true;
    }
}`;
