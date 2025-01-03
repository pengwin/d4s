pub use srv_lib::config::WebhookConfig;
use srv_lib::webhook_srv;
use tokio::task::JoinHandle;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    if dotenvy::dotenv().is_ok() {
        tracing::info!("Loaded .env file");
    }

    let config = WebhookConfig::from_env()?;
    let config_clone = config.clone();
    let exposed_task: JoinHandle<anyhow::Result<()>> = tokio::task::spawn(async move {
        webhook_srv::start_exposed_server(&config_clone).await?;
        Ok(())
    });
    webhook_srv::start_internal_server(&config).await?;

    exposed_task
        .await
        .map_err(|e| anyhow::anyhow!("Error in exposed server task: {:?}", e))??;

    tracing::info!("Server stopped");
    Ok(())
}
