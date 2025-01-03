mod api;

use std::sync::Arc;

use crate::{config::WebhookConfig, signals::shutdown_signal};
use anyhow::Ok;
use api::ServerImpl;
use axum::{routing::get, Router};
use tokio::net::TcpListener;

#[axum::debug_handler]
async fn healthz_handler() -> &'static str {
    "OK"
}

pub async fn start_exposed_server(config: &WebhookConfig) -> anyhow::Result<()> {
    let addr = config.webhook_exposed_endpoint.clone();

    // Init Axum router
    let app = Router::new()
        .route("/healthz", get(healthz_handler));

    tracing::info!("Starting Webhook exposed server on {}", addr);

    // Run the server with graceful shutdown
    let listener = TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await?;

    tracing::info!("Webhook exposed server stopped");

    Ok(())
}

pub async fn start_internal_server(config: &WebhookConfig) -> anyhow::Result<()> {
    let addr = config.webhook_internal_endpoint.clone();

    // Init Axum router
    let app = webhook::server::new(Arc::new(ServerImpl::new(&config.dns_server)));

    tracing::info!("Starting Webhook internal server on {}", addr);

    // Run the server with graceful shutdown
    let listener = TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await?;

    tracing::info!("Webhook internal server stopped");

    Ok(())
}
