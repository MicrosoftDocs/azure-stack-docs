---
title: Use API version profiles with Java in Azure Stack Hub 
description: Learn how to use API version profiles with Java in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 1/13/2022
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/23/2022

# Intent: As an Azure Stack user, I want to use API version profiles with Java in Azure stack so I can benefit from the use of profiles.
# Keyword: azure stack api profiles java

---

# Use API version profiles with Java in Azure Stack Hub

The Java SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include compute, networking, storage, app services, and Azure Key Vault. You can find the [Hybrid Java Samples repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) on GitHub. This article will help you set up your environment, get the right credentials, grab the repository, and create a resource group in Azure Stack Hub.

Using the Java SDK enables a true hybrid cloud developer experience. Switching the version dependencies in the `POM.xml` in the Java SDK enable hybrid cloud development by helping you switch between global Azure resources to resources in Azure Stack Hub.

To use the latest version of the services, use the **latest** profile as the dependency.

You can target your app to resource in Azure tack Hub by taking your existing **com.azure.resourcemanager** dependency and change the version from `x.y.z` to `x.y.z-hybrid`. The hybrid packages, which provide support for Azure Stack Hub, use a `-hybrid` suffix at the end of the version, for example, `1.0.0-hybrid`. This will point to a static collection of endpoints associated with the version.

To get the the latest profile, take your existing **com.azure.resourcemanager** dependency and change the version to **latest**. The **latest** profile Java packages provide a consistent experience with Azure. The packages share the same group ID as Azure **com.azure.resourcemanager**. The artifact ID and namespaces are also the same as global Azure. This helps in porting your Azure app to Azure Stack Hub. To find more about the endpoints used in Azure Stack Hub as par of the hybrid profile, see the [Summary
of API profiles](../user/azure-stack-version-profiles.md#summary-of-api-profiles).

The profile is specified in the `pom.xml` file in the Maven project as a dependency. The profile loads modules automatically if you choose the right class from the dropdown list (as you would with .NET).
## Set up your development environment

To prepare your environment for running the SDK, you can use the IDE that you prefer such as Eclipse or Visual Studio Code. But you will need to have Git, the Java SDK, and Apache Maven installed. You can find details about the prerequisites for the setting up your development environment at [Use the Azure SDK for Java](/azure/developer/java/sdk/overview)

1. Install Git. You can find the official instructions to install Git at [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

1. Install the Java SDK and set your `JAVA_HOME` environment variable to the location of the binaries for Java Development Kit. You can find the downloadable installation media instructions for the [OpenJDK](https://www.microsoft.com/openjdk). Install version 8 or greater of the Java Developer Kit.

1. Install Apache Maven. You can find instruction at [the Apache Maven Project](https://maven.apache.org/). Install Apache Maven is 3.0 or above. 

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the values in the [sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples#setup-secret-service-principal) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) for updated sample code or further information.

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

## Samples

See the [sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) for update-to-date sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

## Next steps

Learn more about API profiles:
- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
