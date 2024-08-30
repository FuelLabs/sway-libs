use crate::native_asset::tests::utils::setup::{AssetLib, Metadata};
use fuels::{
    prelude::{AssetId, CallParameters, TxPolicies, WalletUnlocked},
    programs::responses::CallResponse,
    types::{transaction_builders::VariableOutputPolicy, Bits256, Identity},
};

pub(crate) async fn total_assets(contract: &AssetLib<WalletUnlocked>) -> u64 {
    contract
        .methods()
        .total_assets()
        .call()
        .await
        .unwrap()
        .value
}

pub(crate) async fn total_supply(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
) -> Option<u64> {
    contract
        .methods()
        .total_supply(asset)
        .call()
        .await
        .unwrap()
        .value
}

pub(crate) async fn name(contract: &AssetLib<WalletUnlocked>, asset: AssetId) -> Option<String> {
    contract.methods().name(asset).call().await.unwrap().value
}

pub(crate) async fn symbol(contract: &AssetLib<WalletUnlocked>, asset: AssetId) -> Option<String> {
    contract.methods().symbol(asset).call().await.unwrap().value
}

pub(crate) async fn decimals(contract: &AssetLib<WalletUnlocked>, asset: AssetId) -> Option<u8> {
    contract
        .methods()
        .decimals(asset)
        .call()
        .await
        .unwrap()
        .value
}

pub(crate) async fn mint(
    contract: &AssetLib<WalletUnlocked>,
    recipient: Identity,
    sub_id: Option<Bits256>,
    amount: u64,
) -> CallResponse<()> {
    contract
        .methods()
        .mint(recipient, sub_id, amount)
        .with_variable_output_policy(VariableOutputPolicy::Exactly(1))
        .call()
        .await
        .unwrap()
}

pub(crate) async fn burn(
    contract: &AssetLib<WalletUnlocked>,
    asset_id: AssetId,
    sub_id: Bits256,
    amount: u64,
) -> CallResponse<()> {
    let call_params = CallParameters::new(amount, asset_id, 1_000_000);

    contract
        .methods()
        .burn(sub_id, amount)
        .with_tx_policies(TxPolicies::default().with_script_gas_limit(2_000_000))
        .call_params(call_params)
        .unwrap()
        .call()
        .await
        .unwrap()
}

pub(crate) async fn set_name(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
    name: Option<String>,
) -> CallResponse<()> {
    contract
        .methods()
        .set_name(asset, name.unwrap())
        .call()
        .await
        .unwrap()
}

pub(crate) async fn set_symbol(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
    symbol: Option<String>,
) -> CallResponse<()> {
    contract
        .methods()
        .set_symbol(asset, symbol.unwrap())
        .call()
        .await
        .unwrap()
}

pub(crate) async fn set_decimals(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
    decimals: u8,
) -> CallResponse<()> {
    contract
        .methods()
        .set_decimals(asset, decimals)
        .call()
        .await
        .unwrap()
}

pub(crate) async fn metadata(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
    key: String,
) -> Option<Metadata> {
    contract
        .methods()
        .metadata(asset, key)
        .call()
        .await
        .unwrap()
        .value
}

pub(crate) async fn set_metadata(
    contract: &AssetLib<WalletUnlocked>,
    asset: AssetId,
    key: String,
    metadata: Option<Metadata>,
) -> CallResponse<()> {
    contract
        .methods()
        .set_metadata(asset, key, metadata.unwrap())
        .call()
        .await
        .unwrap()
}
