use rocket::{
    http::Status,
    response::Responder,
    serde::{json::Json, Serialize},
    Request,
};
use thiserror::Error;

/// A wrapper for API responses that can return errors.
pub type ApiResult<T> = Result<Json<T>, ApiError>;

/// An empty response.
#[derive(Serialize)]
pub struct EmptyResponse;

#[derive(Error, Debug)]
pub enum ApiError {
    #[error("Filesystem error: {0}")]
    Filesystem(String),
    #[error("Charcoal error: {0}")]
    Charcoal(String),
    #[error("GitHub error: {0}")]
    Github(String),
}

impl<'r, 'o: 'r> Responder<'r, 'o> for ApiError {
    fn respond_to(self, _request: &'r Request<'_>) -> rocket::response::Result<'o> {
        match self {
            ApiError::Filesystem(_) => Err(Status::InternalServerError),
            ApiError::Charcoal(_) => Err(Status::InternalServerError),
            ApiError::Github(_) => Err(Status::InternalServerError),
        }
    }
}
