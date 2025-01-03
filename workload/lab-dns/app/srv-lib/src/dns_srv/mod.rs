mod request_handler;

use hickory_server::{proto::udp::UdpSocket, ServerFuture};
use request_handler::Handler;

use crate::{config::ServerConfig, storage::Storage};

pub async fn create_dns_server(config: &ServerConfig, storage: &Storage) -> anyhow::Result<ServerFuture<Handler>> {
    let handler = Handler::new(&storage);

    // create DNS server
    let mut server = ServerFuture::new(handler);

    // register UDP listeners
    server.register_socket(UdpSocket::bind(config.udp_endpoint).await?);

    tracing::info!("Starting DNS server on {}", config.udp_endpoint);

    Ok(server)
}
