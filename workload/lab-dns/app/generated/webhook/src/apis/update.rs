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
pub enum AdjustRecordsResponse {
    /// Adjustments were accepted. 
    Status200_AdjustmentsWereAccepted
    (String)
    ,
    /// Adjustments were not accepted. 
    Status500_AdjustmentsWereNotAccepted
}

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[must_use]
#[allow(clippy::large_enum_variant)]
pub enum SetRecordsResponse {
    /// Changes were accepted. 
    Status204_ChangesWereAccepted
    ,
    /// Changes were not accepted. 
    Status500_ChangesWereNotAccepted
}


/// Update
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Update {
    /// Executes the AdjustEndpoints method..
    ///
    /// AdjustRecords - POST /adjustendpoints
    async fn adjust_records(
    &self,
    method: Method,
    host: Host,
    cookies: CookieJar,
            body: Bytes,
    ) -> Result<AdjustRecordsResponse, ()>;

    /// Applies the changes..
    ///
    /// SetRecords - POST /records
    async fn set_records(
    &self,
    method: Method,
    host: Host,
    cookies: CookieJar,
            body: Bytes,
    ) -> Result<SetRecordsResponse, ()>;
}
