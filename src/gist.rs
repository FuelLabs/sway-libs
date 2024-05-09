use octocrab::{models::gists::Gist, Octocrab};

use crate::{
    error::ApiError,
    types::{ContractCode, GistMeta, GistResponse, Language, NewGistRequest},
};

const GIST_SWAY_FILENAME: &str = "playground.sw";
const GIST_SOLIDITY_FILENAME: &str = "playground.sol";

pub struct GistClient {
    octocrab: Octocrab,
}

impl GistClient {
    pub fn default() -> Self {
        let gh_token = std::env::var("GITHUB_API_TOKEN").expect("GITHUB_API_TOKEN must be set");
        let octocrab = Octocrab::builder()
            .personal_token(gh_token)
            .build()
            .expect("octocrab builder");
        Self { octocrab }
    }

    /// Creates a new gist.
    pub async fn create(&self, request: NewGistRequest) -> Result<GistMeta, ApiError> {
        let gist = self
            .octocrab
            .gists()
            .create()
            .file(GIST_SWAY_FILENAME, request.sway_contract.clone())
            .file(
                GIST_SOLIDITY_FILENAME,
                request.transpile_contract.contract.clone(),
            )
            .send()
            .await
            .map_err(|_| ApiError::Github("create gist".into()))?;

        Ok(GistMeta {
            id: gist.id,
            url: gist.html_url.to_string(),
        })
    }

    /// Fetches a gist by ID.
    pub async fn get(&self, id: String) -> Result<GistResponse, ApiError> {
        let gist = self
            .octocrab
            .gists()
            .get(id)
            .await
            .map_err(|_| ApiError::Github("get gist".into()))?;

        let sway_contract = Self::extract_file_contents(&gist, GIST_SWAY_FILENAME);
        let solidity_contract = Self::extract_file_contents(&gist, GIST_SOLIDITY_FILENAME);

        Ok(GistResponse {
            gist: GistMeta {
                id: gist.id,
                url: gist.html_url.to_string(),
            },
            sway_contract,
            transpile_contract: ContractCode {
                contract: solidity_contract,
                language: Language::Solidity,
            },
            error: None,
        })
    }

    fn extract_file_contents(gist: &Gist, filename: &str) -> String {
        gist.files
            .get(filename)
            .map(|file| file.content.clone())
            .unwrap_or_default()
            .unwrap_or_default()
    }
}
