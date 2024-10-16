use rocket::serde::{Deserialize, Serialize};
use std::fmt::{self};

#[derive(Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub enum Language {
    Solidity,
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Toolchain {
    Latest,
    Nightly,
    Testnet,
    Mainnet,
}

impl fmt::Display for Toolchain {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        let s = match self {
            Toolchain::Latest => "latest",
            Toolchain::Nightly => "nightly",
            Toolchain::Testnet => "testnet",
            Toolchain::Mainnet => "mainnet",
        };

        write!(formatter, "{}", s)
    }
}

/// The compile request.
#[derive(Deserialize)]
pub struct CompileRequest {
    pub contract: String,
    pub toolchain: Toolchain,
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

/// A contract's code and its language. Used for contracts in languages other than Sway that can be transpiled.
#[derive(Serialize, Deserialize, Clone)]
pub struct ContractCode {
    pub contract: String,
    pub language: Language,
}

/// The transpile request.
#[derive(Deserialize)]
pub struct TranspileRequest {
    #[serde(flatten)]
    pub contract_code: ContractCode,
}

/// The response to a transpile request.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct TranspileResponse {
    pub sway_contract: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}

/// The new gist request.
#[derive(Deserialize)]
pub struct NewGistRequest {
    pub sway_contract: String,
    pub transpile_contract: ContractCode,
}

/// Information about a gist.
#[derive(Serialize, Deserialize)]
pub struct GistMeta {
    pub id: String,
    pub url: String,
}

/// The response to a new gist request.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct NewGistResponse {
    pub gist: GistMeta,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}

/// The response to a gist request.
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct GistResponse {
    pub gist: GistMeta,
    pub sway_contract: String,
    pub transpile_contract: ContractCode,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}
