use crate::ownership::tests::utils::{
    abi_calls::{owner, renounce_ownership, set_ownership},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert_eq!(owner(&owner1.contract).await, None);

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        assert_eq!(owner(&owner1.contract).await, Some(owner1_identity));

        renounce_ownership(&owner1.contract).await;

        assert_eq!(owner(&owner1.contract).await, None);
    }
}
