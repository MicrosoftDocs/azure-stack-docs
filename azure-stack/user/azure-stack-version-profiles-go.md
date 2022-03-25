---
title: Use API version profiles with Go in Azure Stack Hub 
description: Learn how to use API version profiles with GO in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 12/6/2021
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/23/2022

# Intent: As an Azure Stack user, I want to use API version profiles with Go in Azure Stack so I can benefit from the use of profiles.
# Keyword: azure stack API profiles Go

---

# Use API version profiles with Go in Azure Stack Hub

## Go and version profiles

A profile is a combination of different resource types with different versions from different services. Using a profile helps you mix and match between different resource types. Profiles can provide the following benefits:

- Stability for your app by locking to specific API versions.
- Compatibility for your app with Azure Stack Hub and regional Azure datacenters.

In the Go SDK, profiles are available under the profiles path. Profile version numbers are labeled in the **YYYY-MM-DD** format. For example, Azure Stack Hub API profile version **2020-09-01**  isfor Azure Stack Hub versions 2102 or later. To import a given service from a profile, import its corresponding module from the profile. For example, to import **Compute** service from **2020-09-01** profile, use the following code:

```go
import "github.com/Azure/azure-sdk-for-go/profiles/2020-09-01/compute/mgmt/compute"
```

## Install the Azure SDK for Go

1. Install Git. See [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
1. Install Go. API profiles for Azure require Go version 1.9 or newer. See [Go programming language](https://go.dev/dl/). 

## Profiles
To use a different SDK profile or version, simply substitute the date in an import statement such as `github.com/Azure/azure-sdk-for-go/profiles/<date>/storage/mgmt/storage`. E.g., for 2008 version, the profile is `2019-03-01`, and the string would become `github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/storage/mgmt/storage`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See table below for association of profiles and Azure Stack versions.

| Azure Stack Version | Profile |
|---------------------|---------|
|2108|2020-09-01|
|2102|2020-09-01|
|2008|2019-03-01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

See [Go SDK profiles](https://github.com/Azure/azure-sdk-for-go/tree/main/profiles).

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the README in the [sample repository](https://github.com/Azure-Samples/Hybrid-Golang-Samples) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-Golang-Samples) for updated sample code or further information.

## Tenant Id

To find the directory or tenant Id for your Azure Stack Hub, follow the instructions [in this article](./authenticate-azure-stack-hub.md#get-the-tenant-id).

## Register Resource Providers

Register required resource providers by following this [document](/azure/azure-resource-manager/management/resource-providers-and-types). These resource providers will be required depending on the samples you want to run. For example, if you want to run a VM sample, the `Microsoft.Compute` resource provider registration is required.

## Azure Stack Resource Manager Endpoint

Azure Resource Manager (ARM) is a management framework that enables administrators to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation. You can get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your code.

- The **ResourceManagerEndpointUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/`.
- The **ResourceManagerEndpointUrl** in integrated systems is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.
- To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`.
For available API versions, see [Azure rest API specifications](https://github.com/Azure/azure-rest-api-specs/tree/main/profile). E.g., in `2020-09-01` profile version, you can change the `api-version` to `2019-10-01` for resource provider `microsoft.resources`.

Sample JSON:
```json
{
   "galleryEndpoint": "https://portal.local.azurestack.external:30015/",
   "graphEndpoint": "https://graph.windows.net/",
   "portal Endpoint": "https://portal.local.azurestack.external/",
   "authentication": 
      {
         "loginEndpoint": "https://login.windows.net/",
         "audiences": ["https://management.yourtenant.onmicrosoft.com/3cc5febd-e4b7-4a85-a2ed-1d730e2f5928"]
      }
}
```

## Samples

See the [sample repository](https://github.com/Azure-Samples/Hybrid-Golang-Samples) for update-to-date sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

::: moniker range="<=azs-2008"

See [here](https://github.com/Azure-Samples/Hybrid-Golang-Samples/tree/fe8fdcc6496873f183d56ead8c879442dcaf3dea) for the sample applicable for Azure Stack version `2008` or profile `2019-03-01` and below.

::: moniker-end

## Next steps

Learn more about API profiles:
- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
