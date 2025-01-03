use std::{net::Ipv4Addr, sync::Arc};

use dashmap::DashMap;

#[derive(Clone)]
pub struct Record {
    pub ip: Ipv4Addr,
    pub ttl: u32,
}

#[derive(Clone)]
pub struct Storage {
    records: Arc<DashMap<String, Vec<Record>>>,
}

impl Storage {
    pub fn new() -> Self {
        Self {
            records: Arc::new(DashMap::new()),
        }
    }

    pub fn all(&self) -> Vec<(String, Vec<Record>)> {
        self.records.iter().map(|r| (r.key().clone(), r.value().clone())).collect()
    }

    pub fn insert(&self, key: String, ips: Vec<Ipv4Addr>, ttl: u32) {
        let records = ips.into_iter().map(|ip| Record { ip, ttl }).collect();
        self.records.insert(key, records);
    }

    pub fn get(&self, key: &str) -> Vec<Record> {
        self.records.get(key).map(|r| r.clone()).unwrap_or(Vec::new())
    }

    pub fn delete(&self, key: &str) {
        self.records.remove(key);
    }
}

