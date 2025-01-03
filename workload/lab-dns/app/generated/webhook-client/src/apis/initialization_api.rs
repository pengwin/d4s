/*
 * External DNS Webhook Server
 *
 * Implements the external DNS webhook endpoints.
 *
 * The version of the OpenAPI document: v0.15.0
 * 
 * Generated by: https://openapi-generator.tech
 */

use std::sync::Arc;
use std::borrow::Borrow;
use std::pin::Pin;
#[allow(unused_imports)]
use std::option::Option;

use hyper;
use hyper_util::client::legacy::connect::Connect;
use futures::Future;

use crate::models;
use super::{Error, configuration};
use super::request as __internal_request;

pub struct InitializationApiClient<C: Connect>
    where C: Clone + std::marker::Send + Sync + 'static {
    configuration: Arc<configuration::Configuration<C>>,
}

impl<C: Connect> InitializationApiClient<C>
    where C: Clone + std::marker::Send + Sync {
    pub fn new(configuration: Arc<configuration::Configuration<C>>) -> InitializationApiClient<C> {
        InitializationApiClient {
            configuration,
        }
    }
}

pub trait InitializationApi: Send + Sync {
    fn negotiate(&self, ) -> Pin<Box<dyn Future<Output = Result<models::Filters, Error>> + Send>>;
}

impl<C: Connect>InitializationApi for InitializationApiClient<C>
    where C: Clone + std::marker::Send + Sync {
    #[allow(unused_mut)]
    fn negotiate(&self, ) -> Pin<Box<dyn Future<Output = Result<models::Filters, Error>> + Send>> {
        let mut req = __internal_request::Request::new(hyper::Method::GET, "/".to_string())
        ;

        req.execute(self.configuration.borrow())
    }

}
