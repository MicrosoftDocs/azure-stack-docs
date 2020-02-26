---
title: Supported metrics for Azure Monitor on Azure Stack Hub 
description: Learn about the supported metrics for Azure Monitor on Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 11/11/2019
ms.author: mabrigg
ms.lastreviewed: 11/11/2

# Intent: As an Azure Stack user, I want to use Azure Monitor and I want to know which metrics are supported by its pipeline so I can retrieve them. 
# Keyword: monitor metrics azure stack

---


# Supported metrics for Azure Monitor on Azure Stack Hub

Metrics from Azure monitor on Azure Stack Hub are retrieved in the same way as they are in global Azure. You can create your measures in the portal, get them from the REST API, or query them with PowerShell or CLI.

The following tables list the metrics available with Azure Monitor's metric pipeline on Azure Stack Hub. To query and access these metrics, use the **2018-01-01** api-version version of the API profile. For more information about API profiles and Azure Stack Hub, see [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md).

## Microsoft.Compute/virtualMachines

| Metric | Metric Display Name | Unit | Aggregation Type | Description | Dimensions |
|----------------|---------------------|---------|------------------|-----------------------------------------------------------------------------------------------|---------------|
| Percentage CPU | Percentage CPU | Percent | Average | The percentage of allocated compute units that are currently in use by the VM(s). | No dimensions |

## Microsoft.Storage/storageAccounts

| Metric | Metric Display Name | Unit | Aggregation Type | Description | Dimensions |
|----------------------|------------------------|--------------|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| UsedCapacity | Used capacity | Bytes | Average | Account used capacity. | No dimensions |
| Transactions | Transactions | Count | Total | The number of requests made to a storage service or the specified API operation. This number includes successful and failed requests and also requests which produced errors. Use ResponseType dimension for the number of different types of responses. | ResponseType, GeoType, ApiName |
| Ingress | Ingress | Bytes | Total | The amount of ingress data, in bytes. This number includes ingress from an external client into Azure Storage and also ingress within Azure. | GeoType, ApiName |
| Egress | Egress | Bytes | Total | The amount of egress data, in bytes. This number includes egress from an external client into Azure Storage and also egress within Azure. As a result, this number doesn't reflect billable egress. | GeoType, ApiName |
| SuccessServerLatency | Success Server Latency | Milliseconds | Average | The average latency used by Azure Storage to process a successful request, in milliseconds. This value doesn't include the network latency specified in AverageE2ELatency. | GeoType, ApiName |
| SuccessE2ELatency | Success E2E Latency | Milliseconds | Average | The average end-to-end latency of successful requests made to a storage service or the specified API operation, in milliseconds. This value includes the required processing time within Azure Storage to read the request, send the response, and receive acknowledgment of the response. | GeoType, ApiName |
| Availability | Availability | Percent | Average | The percentage of availability for the storage service or the specified API operation. Calculate availability by taking the TotalBillableRequests value and dividing it by the number of applicable requests, including those requests that produced unexpected errors. All unexpected errors result in reduced availability for the storage service or the specified API operation. | GeoType, ApiName |

## Microsoft.Storage/storageAccounts/blobServices

| Metric | Metric Display Name | Unit | Aggregation Type | Description | Dimensions |
|--------|---------------------|------|------------------|-------------|------------|
| BlobCapacity | Blob Capacity | Bytes | Total | The amount of storage used by the storage account's Blob service in bytes. | BlobType |
| BlobCount | Blob Count | Count | Total | The number of blobs in the storage account's Blob service. | BlobType |
| ContainerCount | Blob Container Count | Count | Average | The number of containers in the storage account's Blob service. | No Dimensions |
| Transactions | Transactions | Count | Total | The number of requests made to a storage service or the specified API operation. This number includes successful and failed requests and also requests which produced errors. Use ResponseType dimension for the number of different types of responses. | ResponseType, GeoType, ApiName |
| Ingress | Ingress | Bytes | Total | The amount of ingress data, in bytes. This number includes ingress from an external client into Azure Storage and also ingress within Azure. | GeoType, ApiName |
| Egress | Egress | Bytes | Total | The amount of egress data, in bytes. This number includes egress from an external client into Azure Storage and also egress within Azure. As a result, this number doesn't reflect billable egress. | GeoType, ApiName |
| SuccessServerLatency | Success Server Latency | Milliseconds | Average | The average latency used by Azure Storage to process a successful request, in milliseconds. This value doesn't include the network latency specified in AverageE2ELatency. | GeoType, ApiName |
| SuccessE2ELatency | Success E2E Latency | Milliseconds | Average | The average end-to-end latency of successful requests made to a storage service or the specified API operation, in milliseconds. This value includes the required processing time within Azure Storage to read the request, send the response, and receive acknowledgment of the response. | GeoType, ApiName |
| Availability | Availability | Percent | Average | The percentage of availability for the storage service or the specified API operation. Calculate availability by taking the TotalBillableRequests value and dividing it by the number of applicable requests, including those requests that produced unexpected errors. All unexpected errors result in reduced availability for the storage service or the specified API operation. | GeoType, ApiName |

## Microsoft.Storage/storageAccounts/tableServices

| Metric | Metric Display Name | Unit | Aggregation Type | Description | Dimensions |
|----------------------|------------------------|--------------|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| TableCapacity | Table Capacity | Bytes | Average | The amount of storage used by the storage account's Table service in bytes. | No Dimensions |
| TableCount | Table Count | Count | Average | The number of tables in the storage account's Table service. | No Dimensions |
| TableEntityCount | Table Entity Count | Count | Average | The number of table entities in the storage account's Table service. | No Dimensions |
| Transactions | Transactions | Count | Total | The number of requests made to a storage service or the specified API operation. This number includes successful and failed requests and also requests which produced errors. Use ResponseType dimension for the number of different types of responses. | ResponseType, GeoType, ApiName |
| Ingress | Ingress | Bytes | Total | The amount of ingress data, in bytes. This number includes ingress from an external client into Azure Storage and also ingress within Azure. | GeoType, ApiName |
| Egress | Egress | Bytes | Total | The amount of egress data, in bytes. This number includes egress from an external client into Azure Storage and also egress within Azure. As a result, this number doesn't reflect billable egress. | GeoType, ApiName |
| SuccessServerLatency | Success Server Latency | Milliseconds | Average | The average latency used by Azure Storage to process a successful request, in milliseconds. This value doesn't include the network latency specified in AverageE2ELatency. | GeoType, ApiName |
| SuccessE2ELatency | Success E2E Latency | Milliseconds | Average | The average end-to-end latency of successful requests made to a storage service or the specified API operation, in milliseconds. This value includes the required processing time within Azure Storage to read the request, send the response, and receive acknowledgment of the response. | GeoType, ApiName |
| Availability | Availability | Percent | Average | The percentage of availability for the storage service or the specified API operation. Calculate availability by taking the TotalBillableRequests value and dividing it by the number of applicable requests, including those requests that produced unexpected errors. All unexpected errors result in reduced availability for the storage service or the specified API operation. | GeoType, ApiName |

## Microsoft.Storage/storageAccounts/queueServices

| Metric | Metric Display Name | Unit | Aggregation Type | Description | Dimensions |
|----------------------|------------------------|--------------|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| QueueCapacity | Queue Capacity | Bytes | Average | The amount of storage used by the storage account's Queue service in bytes. | No Dimensions |
| QueueCount | Queue Count | Count | Average | The number of queues in the storage account's Queue service. | No Dimensions |
| QueueMessageCount | Queue Message Count | Count | Average | The approximate number of queue messages in the storage account's Queue service. | No Dimensions |
| Transactions | Transactions | Count | Total | The number of requests made to a storage service or the specified API operation. This number includes successful and failed requests and also requests which produced errors. Use ResponseType dimension for the number of different types of responses. | ResponseType, GeoType, ApiName |
| Ingress | Ingress | Bytes | Total | The amount of ingress data, in bytes. This number includes ingress from an external client into Azure Storage and also ingress within Azure. | GeoType, ApiName |
| Egress | Egress | Bytes | Total | The amount of egress data, in bytes. This number includes egress from an external client into Azure Storage and also egress within Azure. As a result, this number doesn't reflect billable egress. | GeoType, ApiName |
| SuccessServerLatency | Success Server Latency | Milliseconds | Average | The average latency used by Azure Storage to process a successful request, in milliseconds. This value doesn't include the network latency specified in AverageE2ELatency. | GeoType, ApiName |
| SuccessE2ELatency | Success E2E Latency | Milliseconds | Average | The average end-to-end latency of successful requests made to a storage service or the specified API operation, in milliseconds. This value includes the required processing time within Azure Storage to read the request, send the response, and receive acknowledgment of the response. | GeoType, ApiName |
| Availability | Availability | Percent | Average | The percentage of availability for the storage service or the specified API operation. Calculate availability by taking the TotalBillableRequests value and dividing it by the number of applicable requests, including those requests that produced unexpected errors. All unexpected errors result in reduced availability for the storage service or the specified API operation. | GeoType, ApiName |

## Next steps

Learn more about [Azure monitor on Azure Stack Hub](azure-stack-metrics-azure-data.md).
