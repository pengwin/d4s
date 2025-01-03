# Endpoint

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dns_name** | Option<**String**> |  | [optional]
**targets** | Option<**Vec<String>**> | This is the list of targets that this DNS record points to. So for an A record it will be a list of IP addresses.  | [optional]
**record_type** | Option<**String**> |  | [optional]
**set_identifier** | Option<**String**> |  | [optional]
**record_ttl** | Option<**i64**> |  | [optional]
**labels** | Option<**std::collections::HashMap<String, String>**> |  | [optional]
**provider_specific** | Option<[**Vec<models::ProviderSpecificProperty>**](providerSpecificProperty.md)> |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


