---
title: Use API version profiles with Ruby in Azure Stack Hub 
description: Learn how to use API version profiles with Ruby in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 11/4/2021
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/24/2022

# Intent: As an Azure Stack user, I want to use API version profiles with Ruby in Azure Stack so I can benefit from the use of profiles.
# Keyword: azure stack api profiles ruby

---


# Use API version profiles with Ruby in Azure Stack Hub
## Ruby and API version profiles

The Ruby SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include Compute, Virtual Networks, and Storage, with the Ruby language. API profiles in the Ruby SDK enable hybrid cloud development by helping you switch between global Azure resources and resources on Azure Stack Hub.

An API profile is a combination of resource providers and service versions. You can use an API profile to combine different resource types.

- To use the latest versions of all the services, use the **Latest** profile of the Azure SDK rollup gem.
- To use the services compatible with the Azure Stack Hub, use the **V2020_09_01_Hybrid** or **V2019_03_01_Hybrid** profile of the Azure SDK rollup gem.
- To use the latest **api-version** of a service, use the **Latest** profile of the specific gem. For example, to use the latest **api-version** of compute service alone, use the **Latest** profile of the **Compute** gem.
- To use a specific **api-version** for a service, use the specific API versions defined inside the gem.

> [!NOTE]
> You can combine all of the options in the same app.

## Install the Azure Ruby SDK

- Follow the official instructions to install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- Follow the official instructions to install [Ruby](https://www.ruby-lang.org/en/documentation/installation/).
  - When installing, choose **Add Ruby to PATH variable**.
  - When prompted during Ruby installation, install the development kit.
  - Next, install the bundler using the following command: 

       ```ruby
       Gem install bundler
       ```

## Install the RubyGem packages

You can install the Azure RubyGem packages directly.

```ruby  
gem install azure_mgmt_compute
gem install azure_mgmt_storage
gem install azure_mgmt_resources
gem install azure_mgmt_network
```

Or, use them in your Gemfile.

```ruby
gem 'azure_mgmt_storage'
gem 'azure_mgmt_compute'
gem 'azure_mgmt_resources'
gem 'azure_mgmt_network'
```

The Azure Resource Manager Ruby SDK is in preview and will likely have breaking interface changes in upcoming releases. An increased number in the minor version may indicate breaking changes.

## Use the azure_sdk gem

The **azure_sdk** gem is a rollup of all the supported gems in the Ruby SDK. This gem consists of a **Latest** profile, which supports the latest version of all services. It includes versioned profiles **V2019_03_01_Hybrid** and **2020-09-01-hybrid**, which are built for Azure Stack Hub.

You can install the azure_sdk rollup gem with the following command:  

```ruby  
gem install 'azure_sdk'
```

## Profiles
To use a previous version, simply substitute the `date` in `V<date>_Hybrid`. E.g., for 2008 version, the profile is `2019_03_01`, and the string would become `V2019_03_01_Hybrid`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See table below for association of profiles and Azure Stack versions.

| Azure Stack Version | Profile |
|---------------------|---------|
|2108|2020_09_01|
|2102|2020_09_01|
|2008|2019_03_01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

See [Go SDK profiles](https://github.com/Azure/azure-sdk-for-ruby/tree/master/management).

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the values in the [sample repository](https://github.com/Azure-Samples/Hybrid-CSharp-Samples#setup-secret-service-principal) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-CSharp-Samples) for updated sample code or further information.

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

## Existing API profiles

The **Azure_sdk** rollup gem has the following 3 profiles:

- **V2020-09-01-hybrid**: Profile built for Azure Stack Hub. Use this profile for all the latest versions of services available in Azure Stack Hub version 2102 or later.
- **V2019_03_01_Hybrid**: Profile built for Azure Stack Hub. Use this profile for all the latest versions of services available in Azure Stack Hub version 1904 or later.
- **Latest**: Profile consists of the latest versions of all services. Use the latest versions of all the services.

For more info on Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md#summary-of-api-profiles).

## Samples

See the following sample repositories for update-to-date sample code.

- [Manage Azure resources and resource groups with Ruby](https://github.com/Azure-Samples/Hybrid-Resource-Manager-Ruby-Resources-And-Groups).
- [Manage virtual machines using Ruby](https://github.com/Azure-Samples/Hybrid-Compute-Ruby-Manage-VM)
- [Deploy an SSH Enabled VM with a Template in Ruby](https://github.com/Azure-Samples/Hybrid-Resource-Manager-Ruby-Template-Deployment).

## Next steps

- [Install PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md)
- [Configure the Azure Stack Hub user's PowerShell environment](azure-stack-powershell-configure-user.md)  
