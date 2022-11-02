use crate::nft_extensions::tests::utils::{
    abi_calls::{admin, set_admin},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_admin() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let new_admin = Identity::Address(owner1.wallet.address().into());
        set_admin(Option::Some(new_admin.clone()), &owner1.contract).await;

        assert_eq!(
            admin(&owner1.contract).await,
            Option::Some(new_admin.clone())
        );
    }

    #[tokio::test]
    async fn gets_admin_after_change() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let new_admin = Identity::Address(owner1.wallet.address().into());
        set_admin(Option::Some(new_admin.clone()), &owner1.contract).await;

        assert_eq!(
            admin(&owner1.contract).await,
            Option::Some(new_admin.clone())
        );

        let new_admin2 = Identity::Address(owner2.wallet.address().into());
        set_admin(Option::Some(new_admin2.clone()), &owner1.contract).await;

        assert_eq!(
            admin(&owner1.contract).await,
            Option::Some(new_admin2.clone())
        );
    }
}
