use fuels::{contract::contract::CallResponse, prelude::*,};

// Load abi from json
abigen!(NftCore, "test_projects/nft_core/out/debug/nft_core_test-abi.json");

pub struct Metadata {
    pub contract: NftCore,
    pub wallet: WalletUnlocked,
}

pub mod abi_calls {

    use super::*;

    pub async fn approve(approved: Option<Identity>, contract: &NftCore, token_id: u64) -> CallResponse<()> {
        contract
            .methods()
            .approve(approved, token_id)
            .call()
            .await
            .unwrap()
    }

    pub async fn approved(contract: &NftCore, token_id: u64) -> Option<Identity> {
        contract.methods().approved(token_id).call().await.unwrap().value
    }

    pub async fn balance_of(contract: &NftCore, owner: Identity) -> u64 {
        contract
            .methods()
            .balance_of(owner)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn is_approved_for_all(
        contract: &NftCore,
        operator: Identity,
        owner: Identity,
    ) -> bool {
        contract
            .methods()
            .is_approved_for_all(operator, owner)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn mint(amount: u64, contract: &NftCore, owner: Identity) -> CallResponse<()> {
        contract.methods().mint(amount, owner).call().await.unwrap()
    }

    pub async fn owner_of(contract: &NftCore, token_id: u64) -> Option<Identity> {
        contract.methods().owner_of(token_id).call().await.unwrap().value
    }

    pub async fn set_approval_for_all(
        approve: bool,
        contract: &NftCore,
        operator: Identity,
    ) -> CallResponse<()> {
        contract
            .methods()
            .set_approval_for_all(approve, operator)
            .call()
            .await
            .unwrap()
    }

    pub async fn tokens_minted(contract: &NftCore) -> u64 {
        contract.methods().tokens_minted().call().await.unwrap().value
    }

    pub async fn transfer(
        contract: &NftCore,
        to: Identity,
        token_id: u64,
    ) -> CallResponse<()> {
        contract
            .methods()
            .transfer(to, token_id)
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> (Metadata, Metadata, Metadata) {
        let num_wallets = 4;
        let coins_per_wallet = 1;
        let coin_amount = 1000000;
        let mut wallets = launch_custom_provider_and_get_wallets(
            WalletsConfig::new(Some(num_wallets), Some(coins_per_wallet), Some(coin_amount)), None,
        )
        .await;

        // Get the wallets from that provider
        let wallet1 = wallets.pop().unwrap();
        let wallet2 = wallets.pop().unwrap();
        let wallet3 = wallets.pop().unwrap();

        let nft_id = Contract::deploy(
            "./test_projects/nft/out/debug/nft_core_test.bin",
            &wallet1,
            TxParameters::default(),
            StorageConfiguration::with_storage_path(Some(
                "./test_projects/nft/out/debug/nft_core_test-storage_slots.json".to_string()
            )),
        )
        .await
        .unwrap();

        let deploy_wallet = Metadata {
            contract: NftCore::new(nft_id.to_string(), wallet1.clone()),
            wallet: wallet1.clone(),
        };

        let owner1 = Metadata {
            contract: NftCore::new(nft_id.to_string(), wallet2.clone()),
            wallet: wallet2.clone(),
        };

        let owner2 = Metadata {
            contract: NftCore::new(nft_id.to_string(), wallet3.clone()),
            wallet: wallet3.clone(),
        };

        (deploy_wallet, owner1, owner2)
    }
}
