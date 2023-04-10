contract;

use nft::{
    balance_of,
    extensions::{
        administrator::{
            admin,
            Administrator,
            set_admin,
        },
        burnable::{
            burn,
            Burn,
        },
        supply::{
            max_supply,
            set_max_supply,
            Supply,
        },
        token_metadata::{
            set_token_metadata,
            token_metadata,
            token_metadata_structures::NFTMetadata,
        },
    },
    mint,
    owner_of,
    tokens_minted,
};

abi NFT_Extensions_Test {
    #[storage(read)]
    fn balance_of(owner: Identity) -> u64;
    #[storage(read)]
    fn token_metadata(token_id: u64) -> Option<NFTMetadata>;
    #[storage(read, write)]
    fn mint(amount: u64, to: Identity);
    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity>;
    #[storage(read, write)]
    fn set_token_metadata(token_metadata: Option<NFTMetadata>, token_id: u64);
    #[storage(read)]
    fn tokens_minted() -> u64;
}

impl Administrator for Contract {
    #[storage(read)]
    fn admin() -> Option<Identity> {
        admin()
    }

    #[storage(read, write)]
    fn set_admin(new_admin: Option<Identity>) {
        set_admin(new_admin);
    }
}

impl Burn for Contract {
    #[storage(read, write)]
    fn burn(token_id: u64) {
        burn(token_id);
    }
}

impl NFT_Extensions_Test for Contract {
    #[storage(read)]
    fn balance_of(owner: Identity) -> u64 {
        balance_of(owner)
    }

    #[storage(read)]
    fn token_metadata(token_id: u64) -> Option<NFTMetadata> {
        token_metadata(token_id)
    }

    #[storage(read, write)]
    fn mint(amount: u64, to: Identity) {
        mint(amount, to);
    }

    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity> {
        owner_of(token_id)
    }

    #[storage(read, write)]
    fn set_token_metadata(metadata: Option<NFTMetadata>, token_id: u64) {
        set_token_metadata(metadata, token_id);
    }

    #[storage(read)]
    fn tokens_minted() -> u64 {
        tokens_minted()
    }
}

impl Supply for Contract {
    #[storage(read)]
    fn max_supply() -> Option<u64> {
        max_supply()
    }

    #[storage(read, write)]
    fn set_max_supply(supply: Option<u64>) {
        set_max_supply(supply)
    }
}
