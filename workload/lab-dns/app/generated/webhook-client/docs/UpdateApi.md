# \UpdateApi

All URIs are relative to *http://localhost:8888*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adjust_records**](UpdateApi.md#adjust_records) | **Post** /adjustendpoints | Executes the AdjustEndpoints method.
[**set_records**](UpdateApi.md#set_records) | **Post** /records | Applies the changes.



## adjust_records

> Vec<models::Endpoint> adjust_records(endpoint)
Executes the AdjustEndpoints method.

Adjusts the records in the provider based on those supplied here. 

### Parameters


Name | Type | Description  | Required | Notes
------------- | ------------- | ------------- | ------------- | -------------
**endpoint** | [**Vec<models::Endpoint>**](endpoint.md) | This is the list of changes to be applied.  | [required] |

### Return type

[**Vec<models::Endpoint>**](endpoint.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/external.dns.webhook+json;version=1
- **Accept**: application/external.dns.webhook+json;version=1

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


## set_records

> set_records(changes)
Applies the changes.

Set the records in the DNS provider based on those supplied here. 

### Parameters


Name | Type | Description  | Required | Notes
------------- | ------------- | ------------- | ------------- | -------------
**changes** | [**Changes**](Changes.md) | This is the list of changes that need to be applied.  There are four lists of endpoints.  The `create` and `delete` lists are lists of records to create and delete respectively.  The `updateOld` and `updateNew` lists are paired.  For each entry there's the old version of the record and a new version of the record.  | [required] |

### Return type

 (empty response body)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/external.dns.webhook+json;version=1
- **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

