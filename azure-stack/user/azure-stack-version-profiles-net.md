---
title: Use API version profiles with .NET in Azure Stack Hub 
description: Learn how to use API version profiles with .NET SDK in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 12/6/2021
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/23/2022

# Intent: As an Azure Stack user, I want to use API version profiles with .NET SDK in Azure Stack so I can benefit from the use of profiles
# Keyword: azure stack api profiles .net

---


# Use API version profiles with .NET in Azure Stack Hub

The .NET SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include Compute, Networking, Storage, App Services, and Key Vault. The .NET SDK includes 14 NuGet packages. You must download these packages to your solution every time you compile your project. However, you can specifically download which resource provider you'll use for the **2020-09-01-hybrid** or **2019-03-01-hybrid** versions in order to optimize the memory for your app. Each package consists of a resource provider, the respective API version, and the API profile to which it belongs. API profiles in the .NET SDK enable hybrid cloud development by helping you switch between global Azure resources and resources on Azure Stack Hub.

## Install the Azure .NET SDK

- Install Git. For instructions, see [Getting Started - Installing Git](https://git-scm.com/download).
- To install the correct NuGet packages, see [Available NuGet Distribution Versions](https://www.nuget.org/downloads).

## .NET and API version profiles

An API profile is a combination of resource providers and API versions. Use an API profile to get the latest, most stable version of each resource type in a resource provider package.

- To use the services compatible with Azure Stack Hub, use one of the following packages:
  - **[Microsoft.Azure.Management.Profiles.hybrid\_2020\_09\_01.<*ResourceProvider*>.1.0.0.nupkg](https://www.nuget.org/packages?q=Microsoft.Azure.Management.Profiles.hybrid_2020_09_01)**
  - **[Microsoft.Azure.Management.Profiles.hybrid\_2019\_03\_01.<*ResourceProvider*>.0.9.0-preview.nupkg](https://www.nuget.org/packages?q=Microsoft.Azure.Management.Profiles.hybrid_2019_03_01)**

  Ensure that the **ResourceProvider** portion of the above NuGet package is changed to the correct provider.

## Profiles
For profiles containing dates, to use a different SDK profile or version simply substitute the date in `Microsoft.Azure.Management.Profiles.hybrid_<date>.ResourceManager`. E.g., for 2008 version, the profile is `2019_03_01`, and the string would become `Microsoft.Azure.Management.Profiles.hybrid_2019_03_01.ResourceManager`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See table below for association of profiles and Azure Stack versions.

| Azure Stack Version | Profile |
|---------------------|---------|
|2108|2020_09_01|
|2102|2020_09_01|
|2008|2019_03_01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the README in the [sample repository](https://github.com/Azure-Samples/Hybrid-CSharp-Samples) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-CSharp-Samples) for updated sample code or further information.

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

See the [sample repository](https://github.com/Azure-Samples/Hybrid-CSharp-Samples) for update-to-date sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

::: moniker range="<=azs-2008"

See [here](https://github.com/Azure-Samples/Hybrid-CSharp-Samples/tree/8958588381b80e7d0d62ec4d4c2bb3286802c2a5) for the sample applicable for Azure Stack version `2008` or profile `2019-03-01` and below.

::: moniker-end

## Next steps

Learn more about API profiles:
- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
