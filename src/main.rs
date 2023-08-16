// We ignore this lint because clippy doesn't like the rocket macro for OPTIONS.
#![allow(clippy::let_unit_value)]
#[macro_use]
extern crate rocket;

mod compilation;
mod cors;
mod types;
mod util;

use compilation::build_and_destroy_project;
use cors::Cors;
use rocket::serde::json::Json;
use types::{CompileRequest, CompileResponse};

/// The compile endpoint.
#[post("/compile", data = "<request>")]
fn compile(request: Json<CompileRequest>) -> Json<CompileResponse> {
    let (abi, bytecode, error, forc_version) =
        build_and_destroy_project(request.contract.to_string(), request.toolchain.to_string());

    Json(CompileResponse {
        abi,
        bytecode,
        error,
        forc_version,
    })
}

/// Catches all OPTION requests in order to get the CORS related Fairing triggered.
#[options("/<_..>")]
fn all_options() {
    // Intentionally left empty
}

/// Catch 404 not founds.
#[catch(404)]
fn not_found() -> String {
    "Not found".to_string()
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
        .attach(Cors)
        .mount("/", routes![compile, all_options, health])
        .register("/", catchers![not_found])
}
