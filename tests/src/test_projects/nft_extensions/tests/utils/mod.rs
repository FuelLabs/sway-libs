use fuels::{contract::contract::CallResponse, prelude::*};

// Load abi from json
abigen!(
    NftExtensions,
    "test_projects/nft_extensions/out/debug/nft_extensions_test-abi.json"
);

pub struct Metadata {
    pub contract: NftExtensions,
    pub wallet: WalletUnlocked,
}

pub mod abi_calls {

    use super::*;

    pub async fn admin(
        contract: &NftExtensions,
    ) -> Option<Identity> {
        contract
            .methods()
            .admin()
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn balance_of(contract: &NftExtensions, owner: Identity) -> u64 {
        contract
            .methods()
            .balance_of(owner)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn burn(contract: &NftExtensions, token_id: u64) -> CallResponse<()> {
        contract
            .methods()
            .burn(token_id)
            .call()
            .await
            .unwrap()
    }

    pub async fn meta_data(contract: &NftExtensions, token_id: u64) -> NFTMetaData {
        contract
            .methods()
            .meta_data(token_id)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn mint(amount: u64, contract: &NftExtensions, owner: Identity) -> CallResponse<()> {
        contract.methods().mint(amount, owner).call().await.unwrap()
    }

    pub async fn owner_of(contract: &NftExtensions, token_id: u64) -> Option<Identity> {
        contract
            .methods()
            .owner_of(token_id)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn set_admin(admin: Option<Identity>, contract: &NftExtensions) -> CallResponse<()> {
        contract.methods().set_admin(admin).call().await.unwrap()
    }

    pub async fn set_meta_data(contract: &NftExtensions, token_id: u64, value: u64) -> CallResponse<()> {
        contract.methods().set_meta_data(token_id, value).call().await.unwrap()
    }
 
    pub async fn tokens_minted(contract: &NftExtensions) -> u64 {
        contract
            .methods()
            .tokens_minted()
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn transfer(contract: &NftExtensions, to: Identity, token_id: u64) -> CallResponse<()> {
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
            WalletsConfig::new(Some(num_wallets), Some(coins_per_wallet), Some(coin_amount)),
            None,
        )
        .await;

        // Get the wallets from that provider
        let wallet1 = wallets.pop().unwrap();
        let wallet2 = wallets.pop().unwrap();
        let wallet3 = wallets.pop().unwrap();

        let nft_id = Contract::deploy(
            "./test_projects/nft_extensions/out/debug/nft_extensions_test.bin",
            &wallet1,
            TxParameters::default(),
            StorageConfiguration::default(),
        )
        .await
        .unwrap();

        let deploy_wallet = Metadata {
            contract: NftExtensions::new(nft_id.to_string(), wallet1.clone()),
            wallet: wallet1.clone(),
        };

        let owner1 = Metadata {
            contract: NftExtensions::new(nft_id.to_string(), wallet2.clone()),
            wallet: wallet2.clone(),
        };

        let owner2 = Metadata {
            contract: NftExtensions::new(nft_id.to_string(), wallet3.clone()),
            wallet: wallet3.clone(),
        };

        (deploy_wallet, owner1, owner2)
    }
}
