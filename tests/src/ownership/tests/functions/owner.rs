use crate::ownership::tests::utils::{
    abi_calls::{owner, renounce_ownership, set_ownership},
    abigen_bindings::ownership_lib_mod::State,
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert!(matches!(
            owner(&owner1.contract).await,
            State::Uninitialized
        ));

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        let owner_enum = match owner(&owner1.contract).await {
            State::Initialized(owner) => Some(owner),
            _ => None,
        };
        assert!(owner_enum.is_some());
        assert_eq!(owner_enum.unwrap(), owner1_identity);

        renounce_ownership(&owner1.contract).await;

        assert!(matches!(owner(&owner1.contract).await, State::Revoked));
    }
}
