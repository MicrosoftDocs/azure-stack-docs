---
title: Tenant resource usage APIs reference
titleSuffix: Azure Stack
description: Reference for resource usage APIs, which retrieve Azure Stack Hub usage information.
author: sethmanheim
ms.topic: reference
ms.date: 07/21/2021
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 01/14/2019

# Intent: As an Azure Stack operator, I want a reference for tenant resource usage APIs.
# Keyword: azure stack resource usage APIs reference

---

# Tenant resource usage API reference

A tenant can use the tenant APIs to view the tenant's own resource usage data. These APIs are consistent with the Azure usage APIs.

You can use the Windows PowerShell cmdlet [Get-AzUsageAggregate](/powershell/module/az.billing/get-azusageaggregate) to get usage data, just like in Azure.

## API call

### Request

The request gets consumption details for the requested subscriptions and for the requested time frame. There is no request body.

| **Method** | **Request URI** |
| --- | --- |
| GET |https://{armendpoint}/subscriptions/{subId}/providers/Microsoft.Commerce/usageAggregates?reportedStartTime={reportedStartTime}&reportedEndTime={reportedEndTime}&aggregationGranularity={granularity}&api-version=2015-06-01-preview&continuationToken={token-value} |

### Parameters

| **Parameter** | **Description** |
| --- | --- |
| Armendpoint |Azure Resource Manager endpoint of your Azure Stack Hub environment. The Azure Stack Hub convention is that the name of Azure Resource Manager endpoint is in the format `https://management.{domain-name}`. For example, for the development kit, the domain name is local.azurestack.external, then the Resource Manager  endpoint is `https://management.local.azurestack.external`. |
| subId |Subscription ID of the user who is making the call. You can use this API only to query for a single subscription's usage. Providers can use the provider resource usage API to query usage for all tenants. |
| reportedStartTime |Start time of the query. The value for *DateTime* should be in UTC and at the beginning of the hour; for example, 13:00. For daily aggregation, set this value to UTC midnight. The format is escaped ISO 8601; for example, **2015-06-16T18%3a53%3a11%2b00%3a00Z**, where colon is escaped to %3a and plus is escaped to %2b so that it's URI friendly. |
| reportedEndTime |End time of the query. The constraints that apply to **reportedStartTime** also apply to this parameter. The value for **reportedEndTime** can't be in the future. |
| aggregationGranularity |Optional parameter that has two discrete potential values: **daily** and **hourly**. As the values suggest, one returns the data in daily granularity, and the other is an hourly resolution. The **daily** option is the default. |
| api-version |Version of the protocol that's used to make this request. You must use **2015-06-01-preview**. |
| continuationToken |Token retrieved from the last call to the usage API provider. This token is needed when a response is greater than 1,000 lines. It acts as a bookmark for progress. If not present, the data is retrieved from the beginning of the day or hour, based on the granularity passed in. |

### Response

```html
GET
/subscriptions/sub1/providers/Microsoft.Commerce/UsageAggregates?reportedStartTime=reportedStartTime=2014-05-01T00%3a00%3a00%2b00%3a00&reportedEndTime=2015-06-01T00%3a00%3a00%2b00%3a00&aggregationGranularity=Daily&api-version=1.0
```

```json
{
"value": [
{

"id":
"/subscriptions/sub1/providers/Microsoft.Commerce/UsageAggregate/sub1-meterID1",
"name": "sub1-meterID1",
"type": "Microsoft.Commerce/UsageAggregate",

"properties": {
"subscriptionId":"sub1",
"usageStartTime": "2015-03-03T00:00:00+00:00",
"usageEndTime": "2015-03-04T00:00:00+00:00",
"instanceData":"{\"Microsoft.Resources\":{\"resourceUri\":\"resourceUri1\",\"location\":\"Alaska\",\"tags\":null,\"additionalInfo\":null}}",
"quantity":2.4000000000,
"meterId":"meterID1"

}
},

...
```

### Response details

| **Parameter** | **Description** |
| --- | --- |
| id |Unique ID of the usage aggregate. |
| name |Name of the usage aggregate. |
| type |Resource definition. |
| subscriptionId |Subscription identifier of the Azure user. |
| usageStartTime |UTC start time of the usage bucket to which this usage aggregate belongs. |
| usageEndTime |UTC end time of the usage bucket to which this usage aggregate belongs. |
| instanceData |Key-value pairs of instance details (in a new format):<br>  *resourceUri*: Fully qualified resource ID, including resource groups and instance name. <br>  *location*: Region in which this service was run. <br>  *tags*: Resource tags that the user specifies. <br>  *additionalInfo*: More details about the resource that was consumed. For example, OS version or image type. |
| quantity |Amount of resource consumption that occurred in this time frame. |
| meterId |Unique ID for the resource that was consumed (also called **ResourceID**). |

## Next steps

- [Provider resource usage API](azure-stack-provider-resource-api.md)
- [Usage-related FAQ](azure-stack-usage-related-faq.yml)
