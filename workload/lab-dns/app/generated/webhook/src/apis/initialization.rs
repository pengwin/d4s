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
pub enum NegotiateResponse {
    /// The list of domains this DNS provider serves. 
    Status200_TheListOfDomainsThisDNSProviderServes
    (String)
    ,
    /// Negociation failed. 
    Status500_NegociationFailed
}


/// Initialization
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Initialization {
    /// Initialisation and negotiates headers and returns domain filter..
    ///
    /// Negotiate - GET /
    async fn negotiate(
    &self,
    method: Method,
    host: Host,
    cookies: CookieJar,
    ) -> Result<NegotiateResponse, ()>;
}
