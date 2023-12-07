use crate::admin::tests::utils::{
    abi_calls::{add_admin, only_owner_or_admin, set_ownership},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn only_owner_or_admin_may_call() {
        let (_deployer, owner, admin1, _admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;
        add_admin(&owner.contract, admin1_identity.clone()).await;

        only_owner_or_admin(&owner.contract).await;
        only_owner_or_admin(&admin1.contract).await;
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotAdmin")]
    async fn when_not_owner_or_admin() {
        let (_deployer, owner, admin1, admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;
        add_admin(&owner.contract, admin1_identity.clone()).await;

        only_owner_or_admin(&admin2.contract).await;
    }
}
