---
title: Manage API version profiles in Azure Stack Hub 
description: Learn about API version profiles in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 01/06/2020
ms.author: sethm
ms.reviewer: sijuman
ms.lastreviewed: 07/24/2

# Intent: As an Azure Stack user, I want to create API version profiles so I can create custom clients. 
# Keyword: azure stack api version profiles

---


# Manage API version profiles in Azure Stack Hub

API profiles specify the Azure resource provider and the API version for Azure REST endpoints. You can create custom clients in different languages using API profiles. Each client uses an API profile to contact the correct resource provider and API version for Azure Stack Hub.

You can create an app to work with Azure resource providers without having to sort out exactly which version of each resource provider API is compatible with Azure Stack Hub. Just align your app to a profile and the SDK reverts to the correct API version.

This topic helps you:

- Understand API profiles for Azure Stack Hub.
- Learn how you can use API profiles to develop your solutions.
- See where to find code-specific guidance.

## Summary of API profiles

- API profiles are used to represent a set of Azure resource providers and their API versions.
- API profiles were created for you to create templates across multiple Azure clouds. Profiles provide a compatible and stable interface.
- Profiles are released four times a year.
- Three profile naming conventions are used:
  - **latest**  
        Contains the most recent API versions released in global Azure.
  - **yyyy-mm-dd-hybrid**  
    Released bi-annually, this release focuses on consistency and stability across multiple clouds. This profile targets optimal Azure Stack Hub compatibility.
  - **yyyy-mm-dd-profile** <br>
    Balances optimal stability and the latest features.

## Azure API profiles and Azure Stack Hub compatibility

The newest Azure API profiles are not compatible with Azure Stack Hub. Use the following naming conventions to identify which profiles to use for your Azure Stack Hub solutions:

**Latest**  
This profile has the most up-to-date API versions found in global Azure, which do not work in Azure Stack Hub. **Latest** has the largest number of breaking changes. The profile puts aside stability and compatibility with other clouds. If you're trying to use the most up-to-date API versions, **Latest** is the profile you should use.

**Yyyy-mm-dd-hybrid**  
This profile is released in March and September every year. It has optimal stability and compatibility with various clouds, and is designed to target global Azure and Azure Stack Hub. The Azure API versions listed in this profile will be the same as the ones that are listed in Azure Stack Hub. Use this profile to develop code for hybrid cloud solutions.

**yyyy-mm-dd-profile**  
This profile is released for global Azure in June and December. It does not work with Azure Stack Hub, and there will typically be many breaking changes. Although it balances optimal stability and the latest features, the difference between **Latest** and this profile is that **Latest** always consists of the newest API versions, regardless of when the API is released. For example, if a new API version is created for the Compute API tomorrow, that API version is listed in the **Latest**, but not in the **yyyy-mm-dd-profile** profile, because this profile already exists. **yyyy-mm-dd-profile** covers the most up-to-date versions released before June or before December.

## Azure Resource Manager API profiles

Azure Stack Hub does not use the latest version of the API versions found in global Azure. When you create a solution, you must find the API version for each Azure resource provider that is compatible with Azure Stack Hub.

Rather than research every resource provider and the specific version supported by Azure Stack Hub, you can use an API profile. The profile specifies a set of resource providers and API versions. The SDK, or a tool built with the SDK, will revert to the target `api-version` specified in the profile. With API profiles, you can specify a profile version that applies to an entire template. At runtime, the Azure Resource Manager selects the right version of the resource.

API profiles work with tools that use Azure Resource Manager, such as PowerShell, Azure CLI, code provided in the SDK, and Microsoft Visual Studio. Tools and SDKs can use profiles to read which version of the modules and libraries to include when building an app.

For example, if you use PowerShell to create a storage account using the **Microsoft.Storage** resource provider, which supports **api-version** 2016-03-30 and a VM using the **Microsoft.Compute** resource provider with **api-version** 2015-12-01, you must look up which PowerShell module supports 2016-03-30 for Storage, and which module supports 2015-02-01 for Compute, and then install them. Instead, you can use a profile. Use the cmdlet `Install-Profile <profilename>`, and PowerShell loads the correct version of the modules.

Similarly, when using the Python SDK to build a Python-based app, you can specify the profile. The SDK loads the right modules for the resource providers that you've specified in your script.

As a developer, you can focus on writing your solution. Instead of researching which API versions, resource provider, and cloud work together, you can use a profile and know that your code works across all clouds that support that profile.

## API profile code samples

You can find code samples to help you integrate your solution with your preferred language with Azure Stack Hub by using profiles. Currently, you can find guidance and samples for the following languages:

- **.NET** <br>
Use the .NET API profile to get the latest, most stable version of each resource type in a resource provider package. For more information, see [Use API version profiles with .NET in Azure Stack Hub](azure-stack-version-profiles-net.md).
- **PowerShell**  
Use the  **AzureRM.Bootstrapper** module available through the PowerShell Gallery to get the PowerShell cmdlets required to work with API version profiles. For information, see [Use API version profiles for PowerShell](azure-stack-version-profiles-powershell.md).
- **Azure CLI**  
Update your environment configuration to use the Azure Stack Hub specific API version profile. For information, see [Use API version profiles for Azure CLI](azure-stack-version-profiles-azurecli2.md).
- **Go**  
In the Go SDK, a profile is a combination of different resource types with different versions from different services. Profiles are available under the profiles/path with their version in the **YYYY-MM-DD** format. For information, see [Use API version profiles for Go](azure-stack-version-profiles-go.md).
- **Ruby**  
The Ruby SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include compute, virtual networks, and storage with the Ruby language. For information, see [Use API version profiles with Ruby](azure-stack-version-profiles-ruby.md).
- **Python**  
The Python SDK supports API version profiles to target different cloud platforms such as Azure Stack Hub and global Azure. Use API profiles to create solutions for a hybrid cloud. For information, see [Use API version profiles with Python](azure-stack-version-profiles-python.md).
- **Node.js**  
The Node.js SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. For more information, see [Use API version Profiles with Node.js](azure-stack-version-profile-nodejs.md).

## Next steps

- [Install PowerShell for Azure Stack Hub](../operator/azure-stack-powershell-install.md)
- [Configure the Azure Stack Hub user's PowerShell environment](azure-stack-powershell-configure-user.md)
- [Review details about resource provider API versions supported by the profiles](azure-stack-profiles-azure-resource-manager-versions.md).
