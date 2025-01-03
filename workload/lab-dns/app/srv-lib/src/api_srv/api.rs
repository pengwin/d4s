use std::net::Ipv4Addr;

use axum::{async_trait, body::Bytes, extract::Host, http::Method};
use axum_extra::extract::CookieJar;
use crate::storage::Storage;
use webhook::apis::{
    initialization::NegotiateResponse,
    listing::GetRecordsResponse,
    update::{AdjustRecordsResponse, SetRecordsResponse},
};

pub struct ServerImpl {
    domain: String,
    storage: Storage,
}

impl ServerImpl {
    pub fn new(domain: &str, storage: &Storage) -> Self {
        Self {
            domain: domain.to_string(),
            storage: storage.clone(),
        }
    }

    fn delete_endpoint(&self, endpoint: &webhook::models::Endpoint) -> anyhow::Result<()> {
        let dns_name = endpoint
            .dns_name
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Missing required field: dns_name"))?;

        self.storage.delete(dns_name);

        Ok(())
    }

    fn apply_endpoint(&self, endpoint: &webhook::models::Endpoint) -> anyhow::Result<()> {
        if let Some(record_type) = &endpoint.record_type {
            if record_type != "A" {
                return Err(anyhow::anyhow!("Only A records are supported"));
            }
        }

        let ttl = endpoint.record_ttl.unwrap_or(300);

        let dns_name = endpoint
            .dns_name
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Missing required field: dns_name"))?;

        let targets = endpoint
            .targets
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Missing required field: targets"))?;

        let ips = targets
            .iter()
            .map(|s| s.parse())
            .collect::<Result<Vec<Ipv4Addr>, _>>()?;

        self.storage.insert(dns_name.clone(), ips, ttl as u32);

        Ok(())
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

        let domain = if !self.domain.starts_with(".") {
            format!(".{}", self.domain)
        } else {
            self.domain.clone()
        };
        let filters = webhook::models::Filters {
            filters: Some(vec![domain]),
        };

        let response_str = match serde_json::to_string(&filters) {
            Ok(s) => s,
            Err(e) => {
                tracing::error!("Failed to serialize filters: {}", e);
                return Ok(NegotiateResponse::Status500_NegociationFailed);
            }
        };

        let response =
            NegotiateResponse::Status200_TheListOfDomainsThisDNSProviderServes(response_str);
        Ok(response)
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

        let result: Vec<webhook::models::Endpoint>;

        let records = self.storage.all();

        let mut endpoints = Vec::new();

        for (dns_name, records) in records {
            for record in records {
                let mut endpoint = webhook::models::Endpoint::new();
                endpoint.dns_name = Some(dns_name.clone());
                endpoint.targets = Some(vec![record.ip.to_string()]);
                endpoint.record_type = Some("A".to_string());
                endpoint.record_ttl = Some(record.ttl as i64);
                endpoints.push(endpoint);
            }
        }

        let response = serde_json::to_string(&endpoints);

        let response_str = match response {
            Ok(s) => s,
            Err(e) => {
                tracing::error!("Failed to serialize response: {}", e);
                return Ok(GetRecordsResponse::Status500_FailedToProvideTheListOfDNSRecords);
            }
        };

        Ok(GetRecordsResponse::Status200_ProvidedTheListOfDNSRecordsSuccessfully(response_str))
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

        let request = serde_json::from_slice::<Vec<webhook::models::Endpoint>>(body.as_ref());

        let request: Vec<webhook::models::Endpoint> = match request {
            Ok(endpoints) => endpoints,
            Err(e) => {
                tracing::error!("Failed to parse request: {}", e);
                return Ok(AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted);
            }
        };

        for endpoint in &request {
            if let Err(e) = self.apply_endpoint(&endpoint) {
                tracing::error!("Failed to apply endpoint: {}", e);
                return Ok(AdjustRecordsResponse::Status500_AdjustmentsWereNotAccepted);
            }
        }

        let response = serde_json::to_string(&request);

        let response_str = match response {
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

    async fn set_records(
        &self,
        method: Method,
        host: Host,
        cookies: CookieJar,
        body: Bytes,
    ) -> Result<SetRecordsResponse, ()> {
        tracing::info!("Setting records");

        let request = serde_json::from_slice::<webhook::models::Changes>(body.as_ref());

        let request: webhook::models::Changes = match request {
            Ok(changes) => changes,
            Err(e) => {
                tracing::error!("Failed to parse request: {}", e);
                return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
            }
        };

        if let Some(create) = request.create {
            for endpoint in create {
                if let Err(e) = self.apply_endpoint(&endpoint) {
                    tracing::error!("Failed to apply endpoint: {}", e);
                    return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
                }
            }
        }

        if let Some(update) = request.update_new {
            for endpoint in update {
                if let Err(e) = self.apply_endpoint(&endpoint) {
                    tracing::error!("Failed to apply endpoint: {}", e);
                    return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
                }
            }
        }

        if let Some(update) = request.update_old {
            for endpoint in update {
                if let Err(e) = self.apply_endpoint(&endpoint) {
                    tracing::error!("Failed to apply endpoint: {}", e);
                    return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
                }
            }
        }

        if let Some(delete) = request.delete {
            for endpoint in delete {
                if let Err(e) = self.delete_endpoint(&endpoint) {
                    tracing::error!("Failed to apply endpoint: {}", e);
                    return Ok(SetRecordsResponse::Status500_ChangesWereNotAccepted);
                }
            }
        }

        Ok(SetRecordsResponse::Status204_ChangesWereAccepted)
    }
}
