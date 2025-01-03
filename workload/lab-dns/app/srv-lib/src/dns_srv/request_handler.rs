use hickory_server::{
    authority::MessageResponseBuilder,
    proto::{
        op::Header,
        rr::{LowerName, RData, Record},
    },
    server::{Request, RequestHandler, ResponseHandler, ResponseInfo},
};

use crate::storage::Storage;

/// DNS Request Handler
#[derive(Clone)]
pub struct Handler {
    storage: Storage,
}

impl Handler {
    /// Create new handler from command-line options.
    pub fn new(storage: &Storage) -> Self {
        Handler {
            storage: storage.clone(),
        }
    }

    fn get_records(&self, name: &LowerName) -> Vec<Record> {
        let name_str = name.to_string().trim_end_matches('.').to_string();
        let ips = self.storage.get(&name_str);
        ips.into_iter()
            .map(|rec: crate::storage::Record| {
                let rdata = RData::A(rec.ip.into());
                Record::from_rdata(name.into(), rec.ttl, rdata)
            })
            .collect()
    }

    async fn handle<R: ResponseHandler>(
        &self,
        request: &Request,
        mut responder: R,
    ) -> Result<Option<ResponseInfo>, String> {
        let builder = MessageResponseBuilder::from_message_request(request);
        let mut header = Header::response_from_request(request.header());
        header.set_authoritative(true);
        let name = request.query().name();
        let records = self.get_records(name);
        let response = builder.build(header, records.iter(), &[], &[], &[]);
        let res = responder
            .send_response(response)
            .await
            .map_err(|e| format!("Error sending response: {e}"))?;
        Ok(Some(res))
    }
}

#[async_trait::async_trait]
impl RequestHandler for Handler {
    async fn handle_request<R: ResponseHandler>(
        &self,
        request: &Request,
        response: R,
    ) -> ResponseInfo {
        let req = request.query();
        tracing::info!("Handling request {req}");
        match self.handle(request, response).await {
            Ok(Some(info)) => info,
            Ok(None) => {
                tracing::info!("NXDomain");
                let mut header = Header::new();
                header.set_response_code(hickory_server::proto::op::ResponseCode::ServFail);
                header.into()
            }
            Err(error) => {
                tracing::error!("Error in RequestHandler: {error}");
                let mut header = Header::new();
                header.set_response_code(hickory_server::proto::op::ResponseCode::ServFail);
                header.into()
            }
        }
    }
}
