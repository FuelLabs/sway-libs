use crate::ownership::tests::utils::{
    abi_calls::{renounce_ownership, set_ownership, state},
    ownership_lib_mod::State,
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_state() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert!(matches!(
            state(&owner1.contract).await,
            State::Uninitialized()
        ));

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        assert!(matches!(
            state(&owner1.contract).await,
            State::Initialized()
        ));

        renounce_ownership(&owner1.contract).await;

        assert!(matches!(state(&owner1.contract).await, State::Revoked()));
    }
}
