pub use srv_lib::config::ServerConfig;
use srv_lib::{dns_srv::create_dns_server, storage::Storage, api_srv};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    if dotenvy::dotenv().is_ok() {
        tracing::info!("Loaded .env file");
    }

    let config = ServerConfig::from_env()?;

    let storage = Storage::new();
    /*storage.insert(
        "docker-registry.test-kubernetes.".to_string(),
        "172.16.122.10".parse().unwrap(),
    );
    storage.insert(
        "hello-world.test-kubernetes.".to_string(),
        "172.16.122.10".parse().unwrap(),
    );*/

    let mut dns_server = create_dns_server(&config, &storage).await?;
    api_srv::start_server(&config, &storage).await?;
    
    dns_server.shutdown_gracefully().await?;

    tracing::info!("Server stopped");
    Ok(())
}
