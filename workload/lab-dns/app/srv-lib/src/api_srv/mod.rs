mod api;

use std::sync::Arc;

use crate::{config::ServerConfig, signals::shutdown_signal, storage::Storage};
use anyhow::Ok;
use api::ServerImpl;
use axum::routing::get;
use tokio::net::TcpListener;

#[axum::debug_handler]
async fn healthz_handler() -> &'static str {
    "OK"
}

pub async fn start_server(config: &ServerConfig, storage: &Storage) -> anyhow::Result<()> {
    let addr = config.http_endpoint.clone();

    // Init Axum router
    let app = webhook::server::new(Arc::new(ServerImpl::new(&config.domain_served, storage)))
        .route("/healthz", get(healthz_handler));

    tracing::info!("Starting http API server on {}", addr);

    // Run the server with graceful shutdown
    let listener = TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await?;

    tracing::info!("Http API server stopped");

    Ok(())
}
