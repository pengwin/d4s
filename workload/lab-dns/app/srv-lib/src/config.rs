use std::net::SocketAddr;

use config::Config as ConfigBuilder;
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ServerConfig {
    pub udp_endpoint: SocketAddr,
    pub http_endpoint: String,
    pub domain_served: String,
}

impl ServerConfig {
    pub fn from_env() -> anyhow::Result<Self> {
        let config_source = ConfigBuilder::builder()
            .add_source(config::Environment::with_prefix("DNS"))
            .build()?;

        let config: Self = config_source.try_deserialize()?;
        Ok(config)
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct WebhookConfig {
    pub webhook_exposed_endpoint: String,
    pub webhook_internal_endpoint: String,
    pub dns_server: String,
}

impl WebhookConfig {
    pub fn from_env() -> anyhow::Result<Self> {
        let config_source = ConfigBuilder::builder()
            .add_source(config::Environment::with_prefix("DNS"))
            .build()?;

        let config: Self = config_source.try_deserialize()?;
        Ok(config)
    }
}
