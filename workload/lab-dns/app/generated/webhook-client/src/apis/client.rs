use std::sync::Arc;

use hyper;
use hyper_util::client::legacy::connect::Connect;
use super::configuration::Configuration;

pub struct APIClient {
    initialization_api: Box<dyn crate::apis::InitializationApi>,
    listing_api: Box<dyn crate::apis::ListingApi>,
    update_api: Box<dyn crate::apis::UpdateApi>,
}

impl APIClient {
    pub fn new<C: Connect>(configuration: Configuration<C>) -> APIClient
        where C: Clone + std::marker::Send + Sync + 'static {
        let rc = Arc::new(configuration);

        APIClient {
            initialization_api: Box::new(crate::apis::InitializationApiClient::new(rc.clone())),
            listing_api: Box::new(crate::apis::ListingApiClient::new(rc.clone())),
            update_api: Box::new(crate::apis::UpdateApiClient::new(rc.clone())),
        }
    }

    pub fn initialization_api(&self) -> &dyn crate::apis::InitializationApi{
        self.initialization_api.as_ref()
    }

    pub fn listing_api(&self) -> &dyn crate::apis::ListingApi{
        self.listing_api.as_ref()
    }

    pub fn update_api(&self) -> &dyn crate::apis::UpdateApi{
        self.update_api.as_ref()
    }

}
