use crate::ownership::tests::utils::{abi_calls::{owner, renounce_ownership, set_ownership}, test_helpers::setup};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn renounces_ownership() {
        let (_deployer, owner1, _owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        assert_eq!(owner(&owner1.contract).await, Some(owner1_identity));

        renounce_ownership(&owner1.contract).await;

        assert_eq!(owner(&owner1.contract).await, None);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_not_owner() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity).await;

        renounce_ownership(&owner2.contract).await;
    }

}
