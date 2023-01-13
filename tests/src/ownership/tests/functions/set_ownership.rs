use crate::ownership::tests::utils::{
    abi_calls::{owner, renounce_ownership, set_ownership, state},
    ownership_lib_mod::State,
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn sets_a_new_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert_eq!(owner(&owner1.contract).await, None);
        assert!(matches!(
            state(&owner1.contract).await,
            State::Uninitialized()
        ));

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        assert_eq!(owner(&owner1.contract).await, Some(owner1_identity));
        assert!(matches!(
            state(&owner1.contract).await,
            State::Initialized()
        ));
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "AlreadyInitialized")]
    async fn when_ownership_already_set() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        let owner2_identity = Identity::Address(owner2.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity).await;
        set_ownership(&owner1.contract, owner2_identity).await;
    }

    #[tokio::test]
    #[should_panic(expected = "AlreadyInitialized")]
    async fn when_ownership_revoked() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        let owner2_identity = Identity::Address(owner2.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity).await;

        renounce_ownership(&owner1.contract).await;

        set_ownership(&owner1.contract, owner2_identity).await;
    }
}
