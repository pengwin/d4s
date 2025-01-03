#![allow(unused_qualifications)]

use http::HeaderValue;
use validator::Validate;

#[cfg(feature = "server")]
use crate::header;
use crate::{models, types::*};

      
      
      
      


/// This is the list of changes send by `external-dns` that need to be applied.  There are four lists of endpoints.  The `create` and `delete` lists are lists of records to create and delete respectively.  The `updateOld` and `updateNew` lists are paired. For each entry there's the old version of the record and a new version of the record. 
#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize, validator::Validate)]
#[cfg_attr(feature = "conversion", derive(frunk::LabelledGeneric))]
pub struct Changes {
/// This is a list of DNS records. 
    #[serde(rename = "create")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub create: Option<Vec<models::Endpoint>>,

/// This is a list of DNS records. 
    #[serde(rename = "updateOld")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub update_old: Option<Vec<models::Endpoint>>,

/// This is a list of DNS records. 
    #[serde(rename = "updateNew")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub update_new: Option<Vec<models::Endpoint>>,

/// This is a list of DNS records. 
    #[serde(rename = "delete")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub delete: Option<Vec<models::Endpoint>>,

}


impl Changes {
    #[allow(clippy::new_without_default, clippy::too_many_arguments)]
    pub fn new() -> Changes {
        Changes {
            create: None,
            update_old: None,
            update_new: None,
            delete: None,
        }
    }
}

/// Converts the Changes value to the Query Parameters representation (style=form, explode=false)
/// specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde serializer
impl std::fmt::Display for Changes {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let params: Vec<Option<String>> = vec![
            // Skipping create in query parameter serialization

            // Skipping updateOld in query parameter serialization

            // Skipping updateNew in query parameter serialization

            // Skipping delete in query parameter serialization

        ];

        write!(f, "{}", params.into_iter().flatten().collect::<Vec<_>>().join(","))
    }
}

/// Converts Query Parameters representation (style=form, explode=false) to a Changes value
/// as specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde deserializer
impl std::str::FromStr for Changes {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        /// An intermediate representation of the struct to use for parsing.
        #[derive(Default)]
        #[allow(dead_code)]
        struct IntermediateRep {
            pub create: Vec<Vec<models::Endpoint>>,
            pub update_old: Vec<Vec<models::Endpoint>>,
            pub update_new: Vec<Vec<models::Endpoint>>,
            pub delete: Vec<Vec<models::Endpoint>>,
        }

        let mut intermediate_rep = IntermediateRep::default();

        // Parse into intermediate representation
        let mut string_iter = s.split(',');
        let mut key_result = string_iter.next();

        while key_result.is_some() {
            let val = match string_iter.next() {
                Some(x) => x,
                None => return std::result::Result::Err("Missing value while parsing Changes".to_string())
            };

            if let Some(key) = key_result {
                #[allow(clippy::match_single_binding)]
                match key {
                    "create" => return std::result::Result::Err("Parsing a container in this style is not supported in Changes".to_string()),
                    "updateOld" => return std::result::Result::Err("Parsing a container in this style is not supported in Changes".to_string()),
                    "updateNew" => return std::result::Result::Err("Parsing a container in this style is not supported in Changes".to_string()),
                    "delete" => return std::result::Result::Err("Parsing a container in this style is not supported in Changes".to_string()),
                    _ => return std::result::Result::Err("Unexpected key while parsing Changes".to_string())
                }
            }

            // Get the next key
            key_result = string_iter.next();
        }

        // Use the intermediate representation to return the struct
        std::result::Result::Ok(Changes {
            create: intermediate_rep.create.into_iter().next(),
            update_old: intermediate_rep.update_old.into_iter().next(),
            update_new: intermediate_rep.update_new.into_iter().next(),
            delete: intermediate_rep.delete.into_iter().next(),
        })
    }
}

// Methods for converting between header::IntoHeaderValue<Changes> and HeaderValue

#[cfg(feature = "server")]
impl std::convert::TryFrom<header::IntoHeaderValue<Changes>> for HeaderValue {
    type Error = String;

    fn try_from(hdr_value: header::IntoHeaderValue<Changes>) -> std::result::Result<Self, Self::Error> {
        let hdr_value = hdr_value.to_string();
        match HeaderValue::from_str(&hdr_value) {
             std::result::Result::Ok(value) => std::result::Result::Ok(value),
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Invalid header value for Changes - value: {} is invalid {}",
                     hdr_value, e))
        }
    }
}

#[cfg(feature = "server")]
impl std::convert::TryFrom<HeaderValue> for header::IntoHeaderValue<Changes> {
    type Error = String;

    fn try_from(hdr_value: HeaderValue) -> std::result::Result<Self, Self::Error> {
        match hdr_value.to_str() {
             std::result::Result::Ok(value) => {
                    match <Changes as std::str::FromStr>::from_str(value) {
                        std::result::Result::Ok(value) => std::result::Result::Ok(header::IntoHeaderValue(value)),
                        std::result::Result::Err(err) => std::result::Result::Err(
                            format!("Unable to convert header value '{}' into Changes - {}",
                                value, err))
                    }
             },
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Unable to convert header: {:?} to string: {}",
                     hdr_value, e))
        }
    }
}




/// This is a DNS record. 
#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize, validator::Validate)]
#[cfg_attr(feature = "conversion", derive(frunk::LabelledGeneric))]
pub struct Endpoint {
    #[serde(rename = "dnsName")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub dns_name: Option<String>,

/// This is the list of targets that this DNS record points to. So for an A record it will be a list of IP addresses. 
    #[serde(rename = "targets")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub targets: Option<Vec<String>>,

    #[serde(rename = "recordType")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub record_type: Option<String>,

    #[serde(rename = "setIdentifier")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub set_identifier: Option<String>,

    #[serde(rename = "recordTTL")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub record_ttl: Option<i64>,

    #[serde(rename = "labels")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub labels: Option<std::collections::HashMap<String, String>>,

    #[serde(rename = "providerSpecific")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub provider_specific: Option<Vec<models::ProviderSpecificProperty>>,

}


impl Endpoint {
    #[allow(clippy::new_without_default, clippy::too_many_arguments)]
    pub fn new() -> Endpoint {
        Endpoint {
            dns_name: None,
            targets: None,
            record_type: None,
            set_identifier: None,
            record_ttl: None,
            labels: None,
            provider_specific: None,
        }
    }
}

/// Converts the Endpoint value to the Query Parameters representation (style=form, explode=false)
/// specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde serializer
impl std::fmt::Display for Endpoint {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let params: Vec<Option<String>> = vec![

            self.dns_name.as_ref().map(|dns_name| {
                [
                    "dnsName".to_string(),
                    dns_name.to_string(),
                ].join(",")
            }),


            self.targets.as_ref().map(|targets| {
                [
                    "targets".to_string(),
                    targets.iter().map(|x| x.to_string()).collect::<Vec<_>>().join(","),
                ].join(",")
            }),


            self.record_type.as_ref().map(|record_type| {
                [
                    "recordType".to_string(),
                    record_type.to_string(),
                ].join(",")
            }),


            self.set_identifier.as_ref().map(|set_identifier| {
                [
                    "setIdentifier".to_string(),
                    set_identifier.to_string(),
                ].join(",")
            }),


            self.record_ttl.as_ref().map(|record_ttl| {
                [
                    "recordTTL".to_string(),
                    record_ttl.to_string(),
                ].join(",")
            }),

            // Skipping labels in query parameter serialization

            // Skipping providerSpecific in query parameter serialization

        ];

        write!(f, "{}", params.into_iter().flatten().collect::<Vec<_>>().join(","))
    }
}

/// Converts Query Parameters representation (style=form, explode=false) to a Endpoint value
/// as specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde deserializer
impl std::str::FromStr for Endpoint {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        /// An intermediate representation of the struct to use for parsing.
        #[derive(Default)]
        #[allow(dead_code)]
        struct IntermediateRep {
            pub dns_name: Vec<String>,
            pub targets: Vec<Vec<String>>,
            pub record_type: Vec<String>,
            pub set_identifier: Vec<String>,
            pub record_ttl: Vec<i64>,
            pub labels: Vec<std::collections::HashMap<String, String>>,
            pub provider_specific: Vec<Vec<models::ProviderSpecificProperty>>,
        }

        let mut intermediate_rep = IntermediateRep::default();

        // Parse into intermediate representation
        let mut string_iter = s.split(',');
        let mut key_result = string_iter.next();

        while key_result.is_some() {
            let val = match string_iter.next() {
                Some(x) => x,
                None => return std::result::Result::Err("Missing value while parsing Endpoint".to_string())
            };

            if let Some(key) = key_result {
                #[allow(clippy::match_single_binding)]
                match key {
                    #[allow(clippy::redundant_clone)]
                    "dnsName" => intermediate_rep.dns_name.push(<String as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    "targets" => return std::result::Result::Err("Parsing a container in this style is not supported in Endpoint".to_string()),
                    #[allow(clippy::redundant_clone)]
                    "recordType" => intermediate_rep.record_type.push(<String as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    #[allow(clippy::redundant_clone)]
                    "setIdentifier" => intermediate_rep.set_identifier.push(<String as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    #[allow(clippy::redundant_clone)]
                    "recordTTL" => intermediate_rep.record_ttl.push(<i64 as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    "labels" => return std::result::Result::Err("Parsing a container in this style is not supported in Endpoint".to_string()),
                    "providerSpecific" => return std::result::Result::Err("Parsing a container in this style is not supported in Endpoint".to_string()),
                    _ => return std::result::Result::Err("Unexpected key while parsing Endpoint".to_string())
                }
            }

            // Get the next key
            key_result = string_iter.next();
        }

        // Use the intermediate representation to return the struct
        std::result::Result::Ok(Endpoint {
            dns_name: intermediate_rep.dns_name.into_iter().next(),
            targets: intermediate_rep.targets.into_iter().next(),
            record_type: intermediate_rep.record_type.into_iter().next(),
            set_identifier: intermediate_rep.set_identifier.into_iter().next(),
            record_ttl: intermediate_rep.record_ttl.into_iter().next(),
            labels: intermediate_rep.labels.into_iter().next(),
            provider_specific: intermediate_rep.provider_specific.into_iter().next(),
        })
    }
}

// Methods for converting between header::IntoHeaderValue<Endpoint> and HeaderValue

#[cfg(feature = "server")]
impl std::convert::TryFrom<header::IntoHeaderValue<Endpoint>> for HeaderValue {
    type Error = String;

    fn try_from(hdr_value: header::IntoHeaderValue<Endpoint>) -> std::result::Result<Self, Self::Error> {
        let hdr_value = hdr_value.to_string();
        match HeaderValue::from_str(&hdr_value) {
             std::result::Result::Ok(value) => std::result::Result::Ok(value),
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Invalid header value for Endpoint - value: {} is invalid {}",
                     hdr_value, e))
        }
    }
}

#[cfg(feature = "server")]
impl std::convert::TryFrom<HeaderValue> for header::IntoHeaderValue<Endpoint> {
    type Error = String;

    fn try_from(hdr_value: HeaderValue) -> std::result::Result<Self, Self::Error> {
        match hdr_value.to_str() {
             std::result::Result::Ok(value) => {
                    match <Endpoint as std::str::FromStr>::from_str(value) {
                        std::result::Result::Ok(value) => std::result::Result::Ok(header::IntoHeaderValue(value)),
                        std::result::Result::Err(err) => std::result::Result::Err(
                            format!("Unable to convert header value '{}' into Endpoint - {}",
                                value, err))
                    }
             },
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Unable to convert header: {:?} to string: {}",
                     hdr_value, e))
        }
    }
}




/// external-dns will only create DNS records for host names (specified in ingress objects and services with the external-dns annotation) related to zones that match filters. They can set in external-dns deployment manifest. 
#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize, validator::Validate)]
#[cfg_attr(feature = "conversion", derive(frunk::LabelledGeneric))]
pub struct Filters {
    #[serde(rename = "filters")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub filters: Option<Vec<String>>,

}


impl Filters {
    #[allow(clippy::new_without_default, clippy::too_many_arguments)]
    pub fn new() -> Filters {
        Filters {
            filters: None,
        }
    }
}

/// Converts the Filters value to the Query Parameters representation (style=form, explode=false)
/// specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde serializer
impl std::fmt::Display for Filters {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let params: Vec<Option<String>> = vec![

            self.filters.as_ref().map(|filters| {
                [
                    "filters".to_string(),
                    filters.iter().map(|x| x.to_string()).collect::<Vec<_>>().join(","),
                ].join(",")
            }),

        ];

        write!(f, "{}", params.into_iter().flatten().collect::<Vec<_>>().join(","))
    }
}

/// Converts Query Parameters representation (style=form, explode=false) to a Filters value
/// as specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde deserializer
impl std::str::FromStr for Filters {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        /// An intermediate representation of the struct to use for parsing.
        #[derive(Default)]
        #[allow(dead_code)]
        struct IntermediateRep {
            pub filters: Vec<Vec<String>>,
        }

        let mut intermediate_rep = IntermediateRep::default();

        // Parse into intermediate representation
        let mut string_iter = s.split(',');
        let mut key_result = string_iter.next();

        while key_result.is_some() {
            let val = match string_iter.next() {
                Some(x) => x,
                None => return std::result::Result::Err("Missing value while parsing Filters".to_string())
            };

            if let Some(key) = key_result {
                #[allow(clippy::match_single_binding)]
                match key {
                    "filters" => return std::result::Result::Err("Parsing a container in this style is not supported in Filters".to_string()),
                    _ => return std::result::Result::Err("Unexpected key while parsing Filters".to_string())
                }
            }

            // Get the next key
            key_result = string_iter.next();
        }

        // Use the intermediate representation to return the struct
        std::result::Result::Ok(Filters {
            filters: intermediate_rep.filters.into_iter().next(),
        })
    }
}

// Methods for converting between header::IntoHeaderValue<Filters> and HeaderValue

#[cfg(feature = "server")]
impl std::convert::TryFrom<header::IntoHeaderValue<Filters>> for HeaderValue {
    type Error = String;

    fn try_from(hdr_value: header::IntoHeaderValue<Filters>) -> std::result::Result<Self, Self::Error> {
        let hdr_value = hdr_value.to_string();
        match HeaderValue::from_str(&hdr_value) {
             std::result::Result::Ok(value) => std::result::Result::Ok(value),
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Invalid header value for Filters - value: {} is invalid {}",
                     hdr_value, e))
        }
    }
}

#[cfg(feature = "server")]
impl std::convert::TryFrom<HeaderValue> for header::IntoHeaderValue<Filters> {
    type Error = String;

    fn try_from(hdr_value: HeaderValue) -> std::result::Result<Self, Self::Error> {
        match hdr_value.to_str() {
             std::result::Result::Ok(value) => {
                    match <Filters as std::str::FromStr>::from_str(value) {
                        std::result::Result::Ok(value) => std::result::Result::Ok(header::IntoHeaderValue(value)),
                        std::result::Result::Err(err) => std::result::Result::Err(
                            format!("Unable to convert header value '{}' into Filters - {}",
                                value, err))
                    }
             },
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Unable to convert header: {:?} to string: {}",
                     hdr_value, e))
        }
    }
}




/// Allows provider to pass property specific to their implementation. 
#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize, validator::Validate)]
#[cfg_attr(feature = "conversion", derive(frunk::LabelledGeneric))]
pub struct ProviderSpecificProperty {
    #[serde(rename = "name")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub name: Option<String>,

    #[serde(rename = "value")]
    #[serde(skip_serializing_if="Option::is_none")]
    pub value: Option<String>,

}


impl ProviderSpecificProperty {
    #[allow(clippy::new_without_default, clippy::too_many_arguments)]
    pub fn new() -> ProviderSpecificProperty {
        ProviderSpecificProperty {
            name: None,
            value: None,
        }
    }
}

/// Converts the ProviderSpecificProperty value to the Query Parameters representation (style=form, explode=false)
/// specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde serializer
impl std::fmt::Display for ProviderSpecificProperty {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let params: Vec<Option<String>> = vec![

            self.name.as_ref().map(|name| {
                [
                    "name".to_string(),
                    name.to_string(),
                ].join(",")
            }),


            self.value.as_ref().map(|value| {
                [
                    "value".to_string(),
                    value.to_string(),
                ].join(",")
            }),

        ];

        write!(f, "{}", params.into_iter().flatten().collect::<Vec<_>>().join(","))
    }
}

/// Converts Query Parameters representation (style=form, explode=false) to a ProviderSpecificProperty value
/// as specified in https://swagger.io/docs/specification/serialization/
/// Should be implemented in a serde deserializer
impl std::str::FromStr for ProviderSpecificProperty {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        /// An intermediate representation of the struct to use for parsing.
        #[derive(Default)]
        #[allow(dead_code)]
        struct IntermediateRep {
            pub name: Vec<String>,
            pub value: Vec<String>,
        }

        let mut intermediate_rep = IntermediateRep::default();

        // Parse into intermediate representation
        let mut string_iter = s.split(',');
        let mut key_result = string_iter.next();

        while key_result.is_some() {
            let val = match string_iter.next() {
                Some(x) => x,
                None => return std::result::Result::Err("Missing value while parsing ProviderSpecificProperty".to_string())
            };

            if let Some(key) = key_result {
                #[allow(clippy::match_single_binding)]
                match key {
                    #[allow(clippy::redundant_clone)]
                    "name" => intermediate_rep.name.push(<String as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    #[allow(clippy::redundant_clone)]
                    "value" => intermediate_rep.value.push(<String as std::str::FromStr>::from_str(val).map_err(|x| x.to_string())?),
                    _ => return std::result::Result::Err("Unexpected key while parsing ProviderSpecificProperty".to_string())
                }
            }

            // Get the next key
            key_result = string_iter.next();
        }

        // Use the intermediate representation to return the struct
        std::result::Result::Ok(ProviderSpecificProperty {
            name: intermediate_rep.name.into_iter().next(),
            value: intermediate_rep.value.into_iter().next(),
        })
    }
}

// Methods for converting between header::IntoHeaderValue<ProviderSpecificProperty> and HeaderValue

#[cfg(feature = "server")]
impl std::convert::TryFrom<header::IntoHeaderValue<ProviderSpecificProperty>> for HeaderValue {
    type Error = String;

    fn try_from(hdr_value: header::IntoHeaderValue<ProviderSpecificProperty>) -> std::result::Result<Self, Self::Error> {
        let hdr_value = hdr_value.to_string();
        match HeaderValue::from_str(&hdr_value) {
             std::result::Result::Ok(value) => std::result::Result::Ok(value),
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Invalid header value for ProviderSpecificProperty - value: {} is invalid {}",
                     hdr_value, e))
        }
    }
}

#[cfg(feature = "server")]
impl std::convert::TryFrom<HeaderValue> for header::IntoHeaderValue<ProviderSpecificProperty> {
    type Error = String;

    fn try_from(hdr_value: HeaderValue) -> std::result::Result<Self, Self::Error> {
        match hdr_value.to_str() {
             std::result::Result::Ok(value) => {
                    match <ProviderSpecificProperty as std::str::FromStr>::from_str(value) {
                        std::result::Result::Ok(value) => std::result::Result::Ok(header::IntoHeaderValue(value)),
                        std::result::Result::Err(err) => std::result::Result::Err(
                            format!("Unable to convert header value '{}' into ProviderSpecificProperty - {}",
                                value, err))
                    }
             },
             std::result::Result::Err(e) => std::result::Result::Err(
                 format!("Unable to convert header: {:?} to string: {}",
                     hdr_value, e))
        }
    }
}



