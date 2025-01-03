pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

#[cfg(test)]
mod tests {
    use std::{str::FromStr, thread::JoinHandle};

    use hickory_client::rr::rdata::A;
    use webhook_client::{
        apis::{configuration, client::APIClient as ApiClient},
        models,
    };

    fn configure_client() -> ApiClient {
        let mut configuration = configuration::Configuration::new();
        configuration.base_path = "http://127.0.0.1:8888".to_string();

        ApiClient::new(configuration)
    }

    #[tokio::test]
    async fn initialization_negotiate() -> anyhow::Result<()> {
        let client = configure_client();

        let res = client.initialization_api().negotiate().await
        .map_err(|e| anyhow::format_err!("Negotiate error {:?}", e))?;

        match res.filters {
            Some(filters) => {
                assert_eq!(filters, vec![".test-kubernetes".to_string()]);
            }
            None => {
                panic!("Expected filters to be Some(_)");
            }
        };
        Ok(())
    }

    #[tokio::test]
    async fn update_set_records() -> anyhow::Result<()> {
        let client = configure_client();

        let mut endpoint: models::Endpoint = models::Endpoint::new();
        endpoint.dns_name = Some("hello-world.test-kubernetes".to_string());
        endpoint.targets = Some(vec!["172.16.122.10".to_string()]);
        endpoint.record_type = Some("A".to_string());
        endpoint.record_ttl = Some(65535);

        let mut changes = models::Changes::new();
        changes.create = Some(vec![endpoint]);

        client.update_api().set_records(changes).await
        .map_err(|e| anyhow::format_err!("set_records {:?}", e))?;

        let records = client.listing_api().get_records().await
        .map_err(|e| anyhow::format_err!("get_records {:?}", e))?;

        let record = records.iter().find(|r| r.dns_name == Some("hello-world.test-kubernetes".to_string()));

        assert!(record.is_some(), "record not found");
        let record = record.unwrap();
        assert_eq!(
            record.dns_name,
            Some("hello-world.test-kubernetes".to_string())
        );
        assert_eq!(record.targets, Some(vec!["172.16.122.10".to_string()]));
        assert_eq!(record.record_type, Some("A".to_string()));
        assert_eq!(record.record_ttl, Some(65535));

        Ok(())
    }

    #[tokio::test]
    async fn check_dns_record() -> anyhow::Result<()> {
        let client = configure_client();

        let mut endpoint: models::Endpoint = models::Endpoint::new();
        endpoint.dns_name = Some("docker-registry.test-kubernetes".to_string());
        endpoint.targets = Some(vec!["172.16.122.12".to_string()]);
        endpoint.record_type = Some("A".to_string());
        endpoint.record_ttl = Some(65535);

        client.update_api().adjust_records(vec![endpoint]).await.map_err(|e| anyhow::format_err!("adjust_records {:?}", e))?;

        let records = client.listing_api().get_records().await
        .map_err(|e| anyhow::format_err!("get_records {:?}", e))?;

        let record = records.iter().find(|r| r.dns_name == Some("docker-registry.test-kubernetes".to_string()));

        assert!(record.is_some(), "record not found");

        use hickory_client::client::{Client, SyncClient};
        use hickory_client::op::DnsResponse;
        use hickory_client::rr::{DNSClass, Name, RData, Record, RecordType};
        use hickory_client::udp::UdpClientConnection;

        let thread: JoinHandle<anyhow::Result<DnsResponse>> = std::thread::spawn(move || {
            let address = "127.0.0.1:1053".parse()?;
            let conn = UdpClientConnection::new(address)?;
    
            let client = SyncClient::new(conn);
    
            let name = Name::from_str("docker-registry.test-kubernetes.")?;
            let response: DnsResponse = client.query(&name, DNSClass::IN, RecordType::A)?;

            Ok(response)
        });

        let response = thread.join().unwrap()?;
       
        let answers: &[Record] = response.answers();

        assert_eq!(answers.len(), 1);

        if let Some(RData::A(ref ip)) = answers[0].data() {
            assert_eq!(*ip, A::new(172, 16, 122, 12))
        } else {
            assert!(false, "unexpected result")
        }

        Ok(())
    }
}
