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