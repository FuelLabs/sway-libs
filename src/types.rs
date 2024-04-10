use rocket::serde::{Deserialize, Serialize};
use std::fmt::{self};

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum Language {
    Solidity,
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Toolchain {
    #[serde(rename = "beta-5")]
    Beta5,
    #[serde(rename = "beta-4")]
    Beta4,
    #[serde(rename = "beta-3")]
    Beta3,
    #[serde(rename = "beta-2")]
    Beta2,
    #[serde(rename = "beta-1")]
    Beta1,
    Latest,
    Nightly,
}

impl fmt::Display for Toolchain {
    fn fmt(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        let se = serde_json::to_string(self).map_err(|_| fmt::Error)?;
        write!(formatter, "{}", se)
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
