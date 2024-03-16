use rocket::serde::{Deserialize, Serialize};

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum Language {
    Solidity,
}

/// The compile request.
#[derive(Deserialize)]
pub struct CompileRequest {
    pub contract: String,
    pub toolchain: String,
}

/// The response to a compile request.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CompileResponse {
    pub abi: String,
    pub bytecode: String,
    pub storage_slots: String,
    pub forc_version: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}

/// The transpile request.
#[derive(Deserialize)]
pub struct TranspileRequest {
    pub contract: String,
    pub lanaguage: Language,
}

/// The response to a compile request.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct TranspileResponse {
    pub sway_contract: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}
