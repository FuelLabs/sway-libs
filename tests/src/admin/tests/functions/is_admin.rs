use crate::admin::tests::utils::{
    abi_calls::{is_admin, add_admin, set_ownership},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn checks_if_admin() {
        let (_deployer, owner, admin1, _admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;

        assert!(!is_admin(&owner.contract, admin1_identity.clone()).await);
        set_admin(&owner.contract, admin1_identity.clone()).await;
        assert!(is_admin(&owner.contract, admin1_identity.clone()).await);
    }

    #[tokio::test]
    async fn checks_multiple_admins() {
        let (_deployer, owner, admin1, admin2) = setup().await;

        let owner_identity = Identity::Address(owner.wallet.address().into());
        let admin1_identity = Identity::Address(admin1.wallet.address().into());
        let admin2_identity = Identity::Address(admin2.wallet.address().into());
        set_ownership(&owner.contract, owner_identity.clone()).await;

        assert!(!is_admin(&owner.contract, admin1_identity.clone()).await);
        assert!(!is_admin(&owner.contract, admin2_identity.clone()).await);

        set_admin(&owner.contract, admin1_identity.clone()).await;
        set_admin(&owner.contract, admin2_identity.clone()).await;
        
        assert!(is_admin(&owner.contract, admin1_identity.clone()).await);
        assert!(is_admin(&owner.contract, admin2_identity.clone()).await);
    }
}
