# \ListingApi

All URIs are relative to *http://localhost:8888*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_records**](ListingApi.md#get_records) | **Get** /records | Returns the current records.



## get_records

> Vec<models::Endpoint> get_records()
Returns the current records.

Get the current records from the DNS provider and return them. 

### Parameters

This endpoint does not need any parameter.

### Return type

[**Vec<models::Endpoint>**](endpoint.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/external.dns.webhook+json;version=1

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

