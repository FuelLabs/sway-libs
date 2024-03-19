import { EditorLanguage } from './features/editor/components/ActionOverlay';
import { ExampleMenuItem } from './features/editor/components/ExampleDropdown';

export const FUEL_GREEN = '#00f58c';

export const SERVER_URI = process.env.REACT_APP_LOCAL_SERVER
  ? 'http://0.0.0.0:8080'
  : 'https://api.sway-playground.org';

export const EXAMPLE_SWAY_CONTRACT_COUNTER = `contract;

abi Counter {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64;

    #[storage(read)]
    fn get() -> u64;
}

storage {
    counter: u64 = 0,
}

impl Counter for Contract {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64 {
        let incremented = storage.counter.read() + amount;
        storage.counter.write(incremented);
        incremented
    }

    #[storage(read)]
    fn get() -> u64 {
        storage.counter.read()
    }
}`;

// TODO
export const EXAMPLE_SWAY_CONTRACT_SRC20 = `contract;

use src3::SRC3;
use src5::{SRC5, State, AccessError};
use src20::SRC20;
use std::{
    asset::{
        burn,
        mint_to,
    },
    call_frames::{
        contract_id,
        msg_asset_id,
    },
    constants::DEFAULT_SUB_ID,
    context::msg_amount,
    string::String,
};

abi Constructor {
    #[storage(read, write)]
    fn constructor(owner_: Identity);
}

configurable {
    /// The decimals of the asset minted by this contract.
    DECIMALS: u8 = 9u8,
    /// The name of the asset minted by this contract.
    NAME: str[7] = __to_str_array("MyAsset"),
    /// The symbol of the asset minted by this contract.
    SYMBOL: str[5] = __to_str_array("MYTKN"),
}

storage {
    /// The total supply of the asset minted by this contract.
    total_supply: u64 = 0,
    
    /// Owner.
    owner: State = State::Uninitialized,
}

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        1
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        if asset == AssetId::default() {
            Some(storage.total_supply.read())
        } else {
            None
        }
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        if asset == AssetId::default() {
            Some(String::from_ascii_str(from_str_array(NAME)))
        } else {
            None
        }
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        if asset == AssetId::default() {
            Some(String::from_ascii_str(from_str_array(SYMBOL)))
        } else {
            None
        }
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        if asset == AssetId::default() {
            Some(DECIMALS)
        } else {
            None
        }
    }
}

impl Constructor for Contract {
    #[storage(read, write)]
    fn constructor(owner_: Identity) {
        require(storage.owner.read() == State::Uninitialized, "owner-initialized");
        storage.owner.write(State::Initialized(owner_));
    }
}

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        storage.owner.read()
    }
}

impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: SubId, amount: u64) {
        require(sub_id == DEFAULT_SUB_ID, "Incorrect Sub Id");
        is_owner();

        // Increment total supply of the asset and mint to the recipient.
        storage
            .total_supply
            .write(amount + storage.total_supply.read());
        mint_to(recipient, DEFAULT_SUB_ID, amount);
    }

    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        require(sub_id == DEFAULT_SUB_ID, "Incorrect Sub Id");
        require(msg_amount() >= amount, "Incorrect amount provided");
        require(
            msg_asset_id() == AssetId::default(),
            "Incorrect asset provided",
        );
        is_owner();

        // Decrement total supply of the asset and burn.
        storage
            .total_supply
            .write(storage.total_supply.read() - amount);
        burn(DEFAULT_SUB_ID, amount);
    }
}`;

export const EXAMPLE_SWAY_CONTRACT_3 = `contract;

abi Counter {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64;

    #[storage(read)]
    fn get() -> u64;
}

storage {
    counter: u64 = 0,
}

impl Counter for Contract {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64 {
        let incremented = storage.counter.read() + amount;
        storage.counter.write(incremented);
        incremented
    }

    #[storage(read)]
    fn get() -> u64 {
        storage.counter.read()
    }
}`;

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

export const EXAMPLE_SOLIDITY_CONTRACT_ERC20 = `pragma solidity ^0.8.24;
/// token.sol -- ERC20 implementation with minting and burning.
/// Based on DSToken contract with many modifications.

contract ERC20 {
    address                                           public  owner;
    bool                                              public  stopped;
    uint256                                           public  totalSupply;
    mapping (address => uint256)                      public  balanceOf;
    mapping (address => mapping (address => uint256)) public  allowance;
    string                                            public  symbol;
    uint8                                             public  decimals = 18; // standard token precision. override to customize
    string                                            public  name = "";     // Optional token name

    constructor(string memory symbol_) public {
        symbol = symbol_;
        owner = msg.sender;
    }

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);
    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);
    event Stop();
    event Start();

    function approve(address guy, uint wad) public returns (bool) {
        require(!stopped, "ds-stop-is-stopped");
        allowance[msg.sender][guy] = wad;

        emit Approval(msg.sender, guy, wad);

        return true;
    }

    function transfer(address dst, uint wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(!stopped, "ds-stop-is-stopped");
        if (src != msg.sender && allowance[src][msg.sender] != 0xFFFFFFFFFFFFFFFF) {
            require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
            allowance[src][msg.sender] = allowance[src][msg.sender] - wad;
        }

        require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
        balanceOf[src] = balanceOf[src] - wad;
        balanceOf[dst] = balanceOf[dst] + wad;

        emit Transfer(src, dst, wad);

        return true;
    }

    function mint(address guy, uint wad) public {
        require(!stopped, "ds-stop-is-stopped");
        require(msg.sender == owner, "ds-auth");
        balanceOf[guy] = balanceOf[guy] + wad;
        totalSupply = totalSupply + wad;
        emit Mint(guy, wad);
    }

    function burn(address guy, uint wad) public {
        require(!stopped, "ds-stop-is-stopped");
        require(msg.sender == owner, "ds-auth");
        if (guy != msg.sender && allowance[guy][msg.sender] != 0xFFFFFFFFFFFFFFFF) {
            require(allowance[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
            allowance[guy][msg.sender] = allowance[guy][msg.sender] - wad;
        }

        require(balanceOf[guy] >= wad, "ds-token-insufficient-balance");
        balanceOf[guy] = balanceOf[guy] - wad;
        totalSupply = totalSupply - wad;
        emit Burn(guy, wad);
    }

    function stop() public {
        require(msg.sender == owner, "ds-auth");
        stopped = true;
        emit Stop();
    }

    function start() public {
        require(msg.sender == owner, "ds-auth");
        stopped = false;
        emit Start();
    }

    function setName(string memory name_) public {
        require(msg.sender == owner, "ds-auth");
        name = name_;
    }
    
    function transferOwnership(address owner_) public {
        require(msg.sender == owner, "ds-auth");
        owner = owner_;
    }
}`;

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

export const EXAMPLE_SWAY_CONTRACTS: ExampleMenuItem[] = [
  { label: 'Counter.sw', code: EXAMPLE_SWAY_CONTRACT_COUNTER },
  { label: 'SRC20.sw', code: EXAMPLE_SWAY_CONTRACT_SRC20 },
  { label: 'Example 3', code: EXAMPLE_SWAY_CONTRACT_3 },
];

export const EXAMPLE_SOLIDITY_CONTRACTS: ExampleMenuItem[] = [
  { label: 'Counter.sol', code: EXAMPLE_SOLIDITY_CONTRACT_COUNTER },
  { label: 'ERC20.sol', code: EXAMPLE_SOLIDITY_CONTRACT_ERC20 },
  { label: 'Voting.sol', code: EXAMPLE_SOLIDITY_CONTRACT_VOTING },
];

export const EXAMPLE_CONTRACTS: Record<EditorLanguage, ExampleMenuItem[]> = {
  sway: EXAMPLE_SWAY_CONTRACTS,
  solidity: EXAMPLE_SOLIDITY_CONTRACTS,
};
