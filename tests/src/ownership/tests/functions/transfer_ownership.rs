use crate::ownership::tests::utils::{
    abi_calls::{owner, set_ownership, transfer_ownership},
    ownership_lib_mod::State,
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn transfers_ownership() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        let owner2_identity = Identity::Address(owner2.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        let owner_enum1 = match owner(&owner1.contract).await {
            State::Initialized(owner) => Some(owner),
            _ => None,
        };
        assert!(owner_enum1.is_some());
        assert_eq!(owner_enum1.unwrap(), owner1_identity);

        transfer_ownership(&owner1.contract, owner2_identity.clone()).await;

        let owner_enum2 = match owner(&owner1.contract).await {
            State::Initialized(owner) => Some(owner),
            _ => None,
        };
        assert!(owner_enum2.is_some());
        assert_eq!(owner_enum2.unwrap(), owner2_identity);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_not_owner() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        let owner2_identity = Identity::Address(owner2.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        transfer_ownership(&owner2.contract, owner2_identity).await;
    }
}
