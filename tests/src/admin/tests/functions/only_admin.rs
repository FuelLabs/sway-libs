use crate::admin::tests::utils::{
    abi_calls::{add_admin, only_admin, set_ownership},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn only_admin_may_call() {
        let (_deployer, owner, admin1, _admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;
        add_admin(&owner.contract, admin1_identity.clone()).await;

        only_admin(&admin1.contract).await;
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotAdmin")]
    async fn when_no_admin_set() {
        let (_deployer, _owner, admin1, _admin2) = setup().await;

        only_admin(&admin1.contract).await;
    }

    #[tokio::test]
    #[should_panic(expected = "NotAdmin")]
    async fn when_not_admin() {
        let (_deployer, owner, admin1, admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        let admin2_identity = Identity::Address(admin2.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;
        add_admin(&owner.contract, admin1_identity.clone()).await;

        only_admin(&admin2.contract).await;
    }
}
