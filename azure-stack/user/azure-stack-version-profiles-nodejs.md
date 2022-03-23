---
title: Use API version profiles with Node.js in Azure Stack Hub 
description: Learn about using API version profiles with Node.js in Azure Stack Hub.
author: BryanLa

ms.topic: article
ms.date: 12/6/2021
ms.author: bryanla
ms.reviewer: weshi1
ms.lastreviewed: 3/23/2022

# Intent: As an Azure Stack Hub developer, I want to use NodeJS to create a VM.
# Keyword: Azure Stack NodeJS

---

# Use API version Profiles with Node.js software development kit (SDK) in Azure Stack Hub

## Node.js and API version profiles

You can use Node.js SDK to help build and manage the infrastructure for your apps. API profiles in the Node.js SDK help with your hybrid cloud solutions by letting you switch between global Azure resources and Azure Stack Hub resources. You can code once and then target both global Azure and Azure Stack Hub. 

In this article, you can use [Visual Studio Code](https://code.visualstudio.com/) as your development tool. Visual Studio Code can debug the Node.js SDK and allows you to run the app and push the app to your Azure Stack Hub instance. You can debug from Visual Studio Code or through a terminal window running the command `node <nodefile.js>`.

## The Node.js SDK

The Node.js SDK provides Azure Stack Hub Resource Manager tools. Resource providers in the SDK include compute, networking, storage, app services, and KeyVault. There are 10 resource provider client libraries that you can install in your node.js application. You can also download specify which resource provider you will use for the **2020-09-01-profile** in order to optimize the memory for your application. Each module consists of a resource provider, the respective API version, and the API profile. 

An API profile is a combination of resource providers and API versions. You can use an API profile to get the latest, most stable version of each resource type in a resource provider package.

  -   To make use of the latest versions of all the services, use the **latest** profile of the packages.

  -   To use the services compatible with Azure Stack Hub, use the **\@azure/arm-resources-profile-hybrid-2020-09-01** or **\@azure/arm-storage-profile-2020-09-01-hybrid**

### NPM Packages

Each resource provider has its own package. You can get the package from the [npm registry](https://www.npmjs.com/package/@azure/arm-storage-profile-2020-09-01-hybrid).

You can find the following packages:

| Resource provider | Package |
| --- | --- |
| [App Service](https://www.npmjs.com/package/@azure/arm-resources-profile-2020-09-01-hybrid) | @azure/arm-resources-profile-2020-09-01-hybrid |
| [Azure Resource Manager Subscriptions](https://www.npmjs.com/package/@azure/arm-subscriptions-profile-hybrid-2020-09-01) | @azure/arm-subscriptions-profile-hybrid-2020-09-01  |
| [Azure Resource Manager Policy](https://www.npmjs.com/package/@azure/arm-policy-profile-hybrid-2020-09-01) | @azure/arm-policy-profile-hybrid-2020-09-01
| [Azure Resource Manager DNS](https://www.npmjs.com/package/@azure/arm-dns-profile-2020-09-01-hybrid) | @azure/arm-dns-profile-2020-09-01-hybrid  |
| [Authorization](https://www.npmjs.com/package/@azure/arm-authorization-profile-2020-09-01-hybrid) | @azure/arm-authorization-profile-2020-09-01-hybrid  |
| [Compute](https://www.npmjs.com/package/@azure/arm-compute-profile-2020-09-01-hybrid) | @azure/arm-compute-profile-2020-09-01-hybrid |
| [Storage](https://www.npmjs.com/package/@azure/arm-storage-profile-2020-09-01-hybrid) | @azure/arm-storage-profile-2020-09-01-hybrid |
| [Network](https://www.npmjs.com/package/@azure/arm-network-profile-2020-09-01-hybrid) | @azure/arm-network-profile-2020-09-01-hybrid |
| [Resources](https://www.npmjs.com/package/@azure/arm-resources-profile-hybrid-2020-09-01) | @azure/arm-resources-profile-hybrid-2020-09-01 |
 | [Keyvault](https://www.npmjs.com/package/@azure/arm-keyvault-profile-2020-09-01-hybrid) | @azure/arm-keyvault-profile-2020-09-01-hybrid |

To use the latest API-version of a service, use the **Latest** profile of the specific client library. For example, if you would like to use the latest-API version of resources service alone, use the `azure-arm-resource` profile of the **Resource Management Client Library.** package.

Use the specific API versions defined inside the package for the specific API-versions of a resource provider.

  > [!NOTE]  
  > You can combine all of the options in the same application.

## Profiles
To use a previous version, simply substitute the `date` in `@azure/arm-keyvault-profile-<date>-hybrid`. E.g., for 2008 version, the profile is `2019-03-01`, and the string would become `@azure/arm-keyvault-profile-2019-03-01-hybrid`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See table below for association of profiles and Azure Stack versions.

| Azure Stack Version | Profile |
|---------------------|---------|
|2108|2020-09-01|
|2102|2020-09-01|
|2008|2019-03-01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

## Install the Node.js SDK

1. Install Git. For instructions, see [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

1. Install or upgrade to the current version of [Node.js](https://nodejs.org/en/download/). Node.js also includes the [npm](https://www.npmjs.com/) JavaScript package manager.

1. Install or upgrade [Visual Studio Code](https://code.visualstudio.com/) and install the [Node.js extension](https://code.visualstudio.com/docs/nodejs/nodejs-debugging) for Visual Studio Code.

1. Install the client packages for the Azure Stack Hub Resource Manger. For more information, see [how to install client libraries](https://www.npmjs.com/package/@azure/arm-keyvault-profile-2020-09-01-hybrid).

1. The packages that need to be installed depends on the profile version you would like to use. You can find a list of resource providers in the [Packages in npm](#packages-in-npm) section.

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the values in the [sample repository](https://github.com/Azure-Samples/Hybrid-JavaScript-Samples#setup-secret-service-principal) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-JavaScript-Samples) for updated sample code or further information.

## Tenant Id

To find the directory or tenant Id for your Azure Stack Hub, follow the instructions [in this article](https://docs.microsoft.com/en-us/azure-stack/user/authenticate-azure-stack-hub?view=azs-2108#get-the-tenant-id).

## Register Resource Providers

Register required resource providers by following this [document](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types). These resource providers will be required depending on the samples you want to run. For example, if you want to run VM sample, the `Microsoft.Compute` resource provider registration is required.

## Azure Stack Resource Manager Endpoint

Azure Resource Manager (ARM) is a management framework that enables administrators to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation. You can get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your code.

Consider the following:

- The **ResourceManagerEndpointUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/`.

- The **ResourceManagerEndpointUrl** in integrated systems is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.
- To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`

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

### Existing API profiles

-  **\@azure/arm-resourceprovider-profile-2020-09-01-hybrid**

    Latest Profile built for Azure Stack Hub. Use this profile for services to be most compatible with Azure Stack Hub as long as you are on 1808 stamp or further.

-  **\@azure-arm-resource**

    Profile consists of latest versions of all services. Use the latest versions of all the services in Azure.

For more information about Azure Stack Hub and API profiles, see a [Summary of API profiles](/azure/azure-stack/user/azure-stack-version-profiles#summary-of-api-profiles).

## Samples

See the [sample repository](https://github.com/Azure-Samples/Hybrid-JavaScript-Samples) for update-to-date sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

## Next steps

Learn more about API profiles:
- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
