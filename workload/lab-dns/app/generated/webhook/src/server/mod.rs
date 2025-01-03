use std::collections::HashMap;

use axum::{body::Body, extract::*, response::Response, routing::*};
use axum_extra::extract::{CookieJar, Multipart};
use bytes::Bytes;
use http::{header::CONTENT_TYPE, HeaderMap, HeaderName, HeaderValue, Method, StatusCode};
use tracing::error;
use validator::{Validate, ValidationErrors};

use crate::{header, types::*};

#[allow(unused_imports)]
use crate::{apis, models};


/// Setup API Server.
pub fn new<I, A>(api_impl: I) -> Router
where
    I: AsRef<A> + Clone + Send + Sync + 'static,
    A: apis::initialization::Initialization + apis::listing::Listing + apis::update::Update + 'static,
    
{
    // build our application with a route
    Router::new()
        .route("/",
            get(negotiate::<I, A>)
        )
        .route("/adjustendpoints",
            post(adjust_records::<I, A>)
        )
        .route("/records",
            get(get_records::<I, A>).post(set_records::<I, A>)
        )
        .with_state(api_impl)
}


#[tracing::instrument(skip_all)]
fn negotiate_validation(
) -> std::result::Result<(
), ValidationErrors>
{

Ok((
))
}
/// Negotiate - GET /
#[tracing::instrument(skip_all)]
async fn negotiate<I, A>(
  method: Method,
  host: Host,
  cookies: CookieJar,
 State(api_impl): State<I>,
) -> Result<Response, StatusCode>
where
    I: AsRef<A> + Send + Sync,
    A: apis::initialization::Initialization,
{


      let validation =
    negotiate_validation(
    )
  ;

  let Ok((
  )) = validation else {
    return Response::builder()
            .status(StatusCode::BAD_REQUEST)
            .body(Body::from(validation.unwrap_err().to_string()))
            .map_err(|_| StatusCode::BAD_REQUEST);
  };

  let result = api_impl.as_ref().negotiate(
      method,
      host,
      cookies,
  ).await;

  let mut response = Response::builder();

  let resp = match result {
                                            Ok(rsp) => match rsp {
                                                apis::initialization::NegotiateResponse::Status200_TheListOfDomainsThisDNSProviderServes
                                                    (body)
                                                => {
                                                  let mut response = response.status(200);
                                                  {
                                                    let mut response_headers = response.headers_mut().unwrap();
                                                    response_headers.insert(
                                                        CONTENT_TYPE,
                                                        HeaderValue::from_str("application/external.dns.webhook+json;version=1").map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })?);
                                                  }

                                                  let body_content = body;
                                                  response.body(Body::from(body_content))
                                                },
                                                apis::initialization::NegotiateResponse::Status500_NegociationFailed
                                                => {
                                                  let mut response = response.status(500);
                                                  response.body(Body::empty())
                                                },
                                            },
                                            Err(_) => {
                                                // Application code returned an error. This should not happen, as the implementation should
                                                // return a valid response.
                                                response.status(500).body(Body::empty())
                                            },
                                        };

                                        resp.map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })
}


#[tracing::instrument(skip_all)]
fn get_records_validation(
) -> std::result::Result<(
), ValidationErrors>
{

Ok((
))
}
/// GetRecords - GET /records
#[tracing::instrument(skip_all)]
async fn get_records<I, A>(
  method: Method,
  host: Host,
  cookies: CookieJar,
 State(api_impl): State<I>,
) -> Result<Response, StatusCode>
where
    I: AsRef<A> + Send + Sync,
    A: apis::listing::Listing,
{


      let validation =
    get_records_validation(
    )
  ;

  let Ok((
  )) = validation else {
    return Response::builder()
            .status(StatusCode::BAD_REQUEST)
            .body(Body::from(validation.unwrap_err().to_string()))
            .map_err(|_| StatusCode::BAD_REQUEST);
  };

  let result = api_impl.as_ref().get_records(
      method,
      host,
      cookies,
  ).await;

  let mut response = Response::builder();

  let resp = match result {
                                            Ok(rsp) => match rsp {
                                                apis::listing::GetRecordsResponse::Status200_ProvidedTheListOfDNSRecordsSuccessfully
                                                    (body)
                                                => {
                                                  let mut response = response.status(200);
                                                  {
                                                    let mut response_headers = response.headers_mut().unwrap();
                                                    response_headers.insert(
                                                        CONTENT_TYPE,
                                                        HeaderValue::from_str("application/external.dns.webhook+json;version=1").map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })?);
                                                  }

                                                  let body_content = body;
                                                  response.body(Body::from(body_content))
                                                },
                                                apis::listing::GetRecordsResponse::Status500_FailedToProvideTheListOfDNSRecords
                                                => {
                                                  let mut response = response.status(500);
                                                  response.body(Body::empty())
                                                },
                                            },
                                            Err(_) => {
                                                // Application code returned an error. This should not happen, as the implementation should
                                                // return a valid response.
                                                response.status(500).body(Body::empty())
                                            },
                                        };

                                        resp.map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })
}

    #[derive(validator::Validate)]
    #[allow(dead_code)]
    struct AdjustRecordsBodyValidator<'a> {
          body: &'a [u8],
    }


#[tracing::instrument(skip_all)]
fn adjust_records_validation(
        body: Bytes,
) -> std::result::Result<(
        Bytes,
), ValidationErrors>
{

Ok((
    body,
))
}
/// AdjustRecords - POST /adjustendpoints
#[tracing::instrument(skip_all)]
async fn adjust_records<I, A>(
  method: Method,
  host: Host,
  cookies: CookieJar,
 State(api_impl): State<I>,
          body: Bytes,
) -> Result<Response, StatusCode>
where
    I: AsRef<A> + Send + Sync,
    A: apis::update::Update,
{


      let validation =
    adjust_records_validation(
          body,
    )
  ;

  let Ok((
      body,
  )) = validation else {
    return Response::builder()
            .status(StatusCode::BAD_REQUEST)
            .body(Body::from(validation.unwrap_err().to_string()))
            .map_err(|_| StatusCode::BAD_REQUEST);
  };

  let result = api_impl.as_ref().adjust_records(
      method,
      host,
      cookies,
              body,
  ).await;

  let mut response = Response::builder();

  let resp = match result {
                                            Ok(rsp) => match rsp {
                                                apis::update::AdjustRecordsResponse::Status200_AdjustmentsWereAccepted
                                                    (body)
                                                => {
                                                  let mut response = response.status(200);
                                                  {
                                                    let mut response_headers = response.headers_mut().unwrap();
                                                    response_headers.insert(
                                                        CONTENT_TYPE,
                                                        HeaderValue::from_str("application/external.dns.webhook+json;version=1").map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })?);
                                                  }

                                                  let body_content = body;
                                                  response.body(Body::from(body_content))
                                                },
                                                apis::update::AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted
                                                => {
                                                  let mut response = response.status(500);
                                                  response.body(Body::empty())
                                                },
                                            },
                                            Err(_) => {
                                                // Application code returned an error. This should not happen, as the implementation should
                                                // return a valid response.
                                                response.status(500).body(Body::empty())
                                            },
                                        };

                                        resp.map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })
}

    #[derive(validator::Validate)]
    #[allow(dead_code)]
    struct SetRecordsBodyValidator<'a> {
          body: &'a [u8],
    }


#[tracing::instrument(skip_all)]
fn set_records_validation(
        body: Bytes,
) -> std::result::Result<(
        Bytes,
), ValidationErrors>
{

Ok((
    body,
))
}
/// SetRecords - POST /records
#[tracing::instrument(skip_all)]
async fn set_records<I, A>(
  method: Method,
  host: Host,
  cookies: CookieJar,
 State(api_impl): State<I>,
          body: Bytes,
) -> Result<Response, StatusCode>
where
    I: AsRef<A> + Send + Sync,
    A: apis::update::Update,
{


      let validation =
    set_records_validation(
          body,
    )
  ;

  let Ok((
      body,
  )) = validation else {
    return Response::builder()
            .status(StatusCode::BAD_REQUEST)
            .body(Body::from(validation.unwrap_err().to_string()))
            .map_err(|_| StatusCode::BAD_REQUEST);
  };

  let result = api_impl.as_ref().set_records(
      method,
      host,
      cookies,
              body,
  ).await;

  let mut response = Response::builder();

  let resp = match result {
                                            Ok(rsp) => match rsp {
                                                apis::update::SetRecordsResponse::Status204_ChangesWereAccepted
                                                => {
                                                  let mut response = response.status(204);
                                                  response.body(Body::empty())
                                                },
                                                apis::update::SetRecordsResponse::Status500_ChangesWereNotAccepted
                                                => {
                                                  let mut response = response.status(500);
                                                  response.body(Body::empty())
                                                },
                                            },
                                            Err(_) => {
                                                // Application code returned an error. This should not happen, as the implementation should
                                                // return a valid response.
                                                response.status(500).body(Body::empty())
                                            },
                                        };

                                        resp.map_err(|e| { error!(error = ?e); StatusCode::INTERNAL_SERVER_ERROR })
}

