use crate::nft_core::tests::utils::{
    abi_calls::{is_approved_for_all, set_approval_for_all},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_approval_for_approved() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let owner = Identity::Address(owner1.wallet.address().into());
        let operator = Identity::Address(owner2.wallet.address().into());

        assert_eq!(
            is_approved_for_all(&owner1.contract, operator.clone(), owner.clone()).await,
            false
        );

        set_approval_for_all(true, &owner1.contract, operator.clone()).await;

        assert_eq!(
            is_approved_for_all(&owner1.contract, operator.clone(), owner.clone()).await,
            true
        );
    }

    #[tokio::test]
    async fn gets_approval_for_unapproved() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let owner = Identity::Address(owner1.wallet.address().into());
        let operator = Identity::Address(owner2.wallet.address().into());

        set_approval_for_all(true, &owner1.contract, operator.clone()).await;

        assert_eq!(
            is_approved_for_all(&owner1.contract, owner.clone(), operator.clone()).await,
            false
        );
    }
}
