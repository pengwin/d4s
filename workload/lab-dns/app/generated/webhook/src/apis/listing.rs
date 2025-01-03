use async_trait::async_trait;
use axum::extract::*;
use axum_extra::extract::{CookieJar, Multipart};
use bytes::Bytes;
use http::Method;
use serde::{Deserialize, Serialize};

use crate::{models, types::*};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[must_use]
#[allow(clippy::large_enum_variant)]
pub enum GetRecordsResponse {
    /// Provided the list of DNS records successfully. 
    Status200_ProvidedTheListOfDNSRecordsSuccessfully
    (String)
    ,
    /// Failed to provide the list of DNS records. 
    Status500_FailedToProvideTheListOfDNSRecords
}


/// Listing
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Listing {
    /// Returns the current records..
    ///
    /// GetRecords - GET /records
    async fn get_records(
    &self,
    method: Method,
    host: Host,
    cookies: CookieJar,
    ) -> Result<GetRecordsResponse, ()>;
}
