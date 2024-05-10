// We ignore this lint because clippy doesn't like the rocket macro for OPTIONS.
#![allow(clippy::let_unit_value)]
#[macro_use]
extern crate rocket;

mod compilation;
mod cors;
mod error;
mod gist;
mod transpilation;
mod types;
mod util;

use crate::compilation::build_and_destroy_project;
use crate::cors::Cors;
use crate::error::ApiResult;
use crate::gist::GistClient;
use crate::types::{
    CompileRequest, CompileResponse, GistResponse, Language, NewGistRequest, NewGistResponse,
    TranspileRequest,
};
use crate::{transpilation::solidity_to_sway, types::TranspileResponse};
use rocket::serde::json::Json;
use rocket::State;

/// The endpoint to compile a Sway contract.
#[post("/compile", data = "<request>")]
fn compile(request: Json<CompileRequest>) -> ApiResult<CompileResponse> {
    let response =
        build_and_destroy_project(request.contract.to_string(), request.toolchain.to_string())?;
    Ok(Json(response))
}

/// The endpoint to transpile a contract written in another language into Sway.
#[post("/transpile", data = "<request>")]
fn transpile(request: Json<TranspileRequest>) -> ApiResult<TranspileResponse> {
    let response = match request.contract_code.language {
        Language::Solidity => solidity_to_sway(request.contract_code.contract.to_string()),
    }?;
    Ok(Json(response))
}

/// The endpoint to create a new gist to store the playground editors' code.
#[post("/gist", data = "<request>")]
async fn new_gist(
    request: Json<NewGistRequest>,
    gist: &State<GistClient>,
) -> ApiResult<NewGistResponse> {
    let gist = gist.create(request.into_inner()).await?;
    Ok(Json(NewGistResponse { gist, error: None }))
}

/// The endpoint to fetch a gist.
#[get("/gist/<id>")]
async fn get_gist(id: String, gist: &State<GistClient>) -> ApiResult<GistResponse> {
    let gist_response = gist.get(id).await?;
    Ok(Json(gist_response))
}

/// Catches all OPTION requests in order to get the CORS related Fairing triggered.
#[options("/<_..>")]
fn all_options() {
    // Intentionally left empty
}

// Indicates the service is running
#[get("/health")]
fn health() -> String {
    "true".to_string()
}

// Launch the rocket server.
#[launch]
fn rocket() -> _ {
    rocket::build()
        .manage(GistClient::default())
        .attach(Cors)
        .mount(
            "/",
            routes![compile, transpile, new_gist, get_gist, all_options, health],
        )
}
