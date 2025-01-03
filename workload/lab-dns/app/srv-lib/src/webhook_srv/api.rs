use axum::{async_trait, body::Bytes, extract::Host, http::Method};
use axum_extra::extract::CookieJar;

use webhook::apis::{
    initialization::NegotiateResponse,
    listing::GetRecordsResponse,
    update::{AdjustRecordsResponse, SetRecordsResponse},
};
use webhook_client::apis::client::APIClient as ApiClient;

pub struct ServerImpl {
    client: ApiClient,
}

impl ServerImpl {
    pub fn new(dns_server: &str) -> Self {
        Self { client: Self::create_client(dns_server) }
    }

    fn create_client(dns_server: &str) -> ApiClient {
        let mut configuration = webhook_client::apis::configuration::Configuration::default();
        configuration.base_path = dns_server.to_string();
        ApiClient::new(configuration)
    }
}

#[allow(unused_variables)]
#[async_trait]
impl webhook::apis::initialization::Initialization for ServerImpl {
    async fn negotiate(
        &self,
        method: Method,
        host: Host,
        cookies: CookieJar,
    ) -> Result<NegotiateResponse, ()> {
        tracing::info!("Negotiating");

        let res = self.client.initialization_api().negotiate().await;

        match res {
            Ok(filters) => {
                let response_str = match serde_json::to_string(&filters) {
                    Ok(s) => s,
                    Err(e) => {
                        tracing::error!("Failed to serialize filters: {:?}", e);
                        return Ok(NegotiateResponse::Status500_NegociationFailed);
                    }
                };

                let response = NegotiateResponse::Status200_TheListOfDomainsThisDNSProviderServes(
                    response_str,
                );
                Ok(response)
            }
            Err(e) => {
                tracing::error!("Failed to negotiate: {:?}", e);
                return Ok(NegotiateResponse::Status500_NegociationFailed);
            }
        }
    }
}

#[allow(unused_variables)]
#[async_trait]
impl webhook::apis::listing::Listing for ServerImpl {
    async fn get_records(
        &self,
        method: Method,
        host: Host,
        cookies: CookieJar,
    ) -> Result<GetRecordsResponse, ()> {
        tracing::info!("Getting records");

        let res = self.client.listing_api().get_records().await;

        match res {
            Ok(records) => {
                let response_str = match serde_json::to_string(&records) {
                    Ok(s) => s,
                    Err(e) => {
                        tracing::error!("Failed to serialize records: {}", e);
                        return Ok(
                            GetRecordsResponse::Status500_FailedToProvideTheListOfDNSRecords,
                        );
                    }
                };

                Ok(
                    GetRecordsResponse::Status200_ProvidedTheListOfDNSRecordsSuccessfully(
                        response_str,
                    ),
                )
            }
            Err(e) => {
                tracing::error!("Failed to get records: {:?}", e);
                return Ok(GetRecordsResponse::Status500_FailedToProvideTheListOfDNSRecords);
            }
        }
    }
}

#[allow(unused_variables)]
#[async_trait]
impl webhook::apis::update::Update for ServerImpl {
    async fn adjust_records(
        &self,
        method: Method,
        host: Host,
        cookies: CookieJar,
        body: Bytes,
    ) -> Result<AdjustRecordsResponse, ()> {
        tracing::info!("Adjusting records");

        let request =
            serde_json::from_slice::<Vec<webhook_client::models::Endpoint>>(body.as_ref());
        let request: Vec<webhook_client::models::Endpoint> = match request {
            Ok(endpoints) => endpoints,
            Err(e) => {
                tracing::error!("Failed to parse request: {}", e);
                return Ok(AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted);
            }
        };

        let res = self.client.update_api().adjust_records(request).await;

        match res {
            Ok(endpoints) => {
                let response_str = match serde_json::to_string(&endpoints) {
                    Ok(s) => s,
                    Err(e) => {
                        tracing::error!("Failed to serialize response: {}", e);
                        return Ok(AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted);
                    }
                };

                Ok(AdjustRecordsResponse::Status200_AdjustmentsWereAccepted(
                    response_str,
                ))
            }
            Err(e) => {
                tracing::error!("Failed to adjust records: {:?}", e);
                return Ok(AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted);
            }
        }
    }

    async fn set_records(
        &self,
        method: Method,
        host: Host,
        cookies: CookieJar,
        body: Bytes,
    ) -> Result<SetRecordsResponse, ()> {
        tracing::info!("Setting records");

        let request = serde_json::from_slice::<webhook_client::models::Changes>(body.as_ref());

        let request: webhook_client::models::Changes = match request {
            Ok(changes) => changes,
            Err(e) => {
                tracing::error!("Failed to parse request: {}", e);
                return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
            }
        };

        let res = self.client.update_api().set_records(request).await;

        match res {
            Ok(_) => Ok(SetRecordsResponse::Status204_ChangesWereAccepted),
            Err(e) => {
                tracing::error!("Failed to set records: {:?}", e);
                return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
            }
        }
    }
}
