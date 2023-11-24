use crate::admin::tests::utils::{
    abi_calls::{add_admin, is_admin, set_ownership},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn adds_admin() {
        let (_deployer, owner, admin1, _admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;

        assert!(!is_admin(&owner.contract, admin1_identity.clone()).await);
        add_admin(&owner.contract, admin1_identity.clone()).await;
        assert!(is_admin(&owner.contract, admin1_identity.clone()).await);
    }

    #[tokio::test]
    async fn adds_multiple_admins() {
        let (_deployer, owner, admin1, admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        let admin2_identity = Identity::Address(admin2.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;

        assert!(!is_admin(&owner.contract, admin1_identity.clone()).await);
        assert!(!is_admin(&owner.contract, admin2_identity.clone()).await);

        add_admin(&owner.contract, admin1_identity.clone()).await;
        add_admin(&owner.contract, admin2_identity.clone()).await;

        assert!(is_admin(&owner.contract, admin1_identity.clone()).await);
        assert!(is_admin(&owner.contract, admin2_identity.clone()).await);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_caller_is_not_owner() {
        let (_deployer, owner, admin1, _admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;

        add_admin(&admin1.contract, admin1_identity.clone()).await;
    }
}
