---
title: Differences between Azure Stack Hub and Azure when using services and building apps| Microsoft Docs
description: Understand the differences between Azure and Azure Stack Hub when using services and building apps.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid: c81f551d-c13e-47d9-a5c2-eb1ea4806228
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: overview
ms.date: 01/06/2020
ms.author: sethm
ms.lastreviewed: 12/27/2018

---

# Differences between Azure Stack Hub and Azure when using services and building apps

Before you use services or build apps for Azure Stack Hub, it's important to understand the differences between Azure Stack Hub and Azure. This article identifies different features and key considerations when using Azure Stack Hub as your hybrid cloud development environment.

## Overview

Azure Stack Hub is a hybrid cloud platform that enables you to use Azure services from your company or service provider datacenter. You can build an app on Azure Stack Hub and then deploy it to Azure Stack Hub, to Azure, or to your Azure hybrid cloud.

Your Azure Stack Hub operator tells you which services are available for you to use, and how to get support. They offer these services through their customized plans and offers.

The [Azure technical documentation content](/azure) assumes that apps are being developed for an Azure service and not for Azure Stack Hub. When you build and deploy apps to Azure Stack Hub, you must understand some key differences, such as:

* Azure Stack Hub delivers a subset of the services and features that are available in Azure.
* Your company or service provider can choose which services they want to offer. The available options might include customized services or applications. They may offer their own customized documentation.
* You must use the correct Azure Stack Hub-specific endpoints (for example, the URLs for the portal address and the Azure Resource Manager endpoint).
* You must use PowerShell and API versions that are supported by Azure Stack Hub. Using supported versions ensures that your apps work in both Azure Stack Hub and Azure.

## Cheat sheet: High-level differences

The following table describes the high-level differences between Azure Stack Hub and Azure. Keep these differences in mind when you develop for Azure Stack Hub or use Azure Stack Hub services:

| Area | Azure (global) | Azure Stack Hub |
| -------- | ------------- | ----------|
| Who operates it? | Microsoft | Your organization or service provider.|
| Who do you contact for support? | Microsoft | For an integrated system, contact your Azure Stack Hub operator (at your organization or service provider) for support.<br><br>For Azure Stack Development Kit (ASDK) support, visit the [Microsoft forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=AzureStack). Because the development kit is an evaluation environment, there's no official support offered through Microsoft Customer Support Services (CSS).
| Available services | See the list of [Azure products](https://azure.microsoft.com/services/?b=17.04b). Available services vary by Azure region. | Azure Stack Hub supports a subset of Azure services. Actual services will vary based on what your organization or service provider chooses to offer.
| Azure Resource Manager endpoint* | https://management.azure.com | For an Azure Stack Hub integrated system, use the endpoint that your Azure Stack Hub operator provides.<br><br>For the development kit, use: https://management.local.azurestack.external.
| Portal URL* | [https://portal.azure.com](https://portal.azure.com) | For an Azure Stack Hub integrated system, use the URL that your Azure Stack Hub operator provides.<br><br>For the development kit, use: https://portal.local.azurestack.external.
| Region | You can select which region you want to deploy to. | For an  Azure Stack Hub integrated system, use the region that's available on your system.<br><br>For the Azure Stack Development Kit (ASDK), the region will always be **local**.
| Resource groups | A resource group can span regions. | For both integrated systems and the development kit, there's only one region.
|Supported namespaces, resource types, and API versions | The latest (or earlier versions that aren't yet deprecated). | Azure Stack Hub supports specific versions. See the [Version requirements](#version-requirements) section of this article.
| | |

*If you're an Azure Stack Hub operator, see [Using the administrator portal](../operator/azure-stack-manage-portals.md) and [Administration basics](../operator/azure-stack-manage-basics.md) for more information.

## Helpful tools and best practices

Microsoft provides tools and guidance that help you develop for Azure Stack Hub.

| Recommendation | References |
| -------- | ------------- |
| Install the correct tools on your developer workstation. | - [Install PowerShell](../operator/azure-stack-powershell-install.md)<br>- [Download tools](../operator/azure-stack-powershell-download.md)<br>- [Configure PowerShell](azure-stack-powershell-configure-user.md)<br>- [Install Visual Studio](azure-stack-install-visual-studio.md)
| Review information about the following items:<br>- Azure Resource Manager template considerations.<br>- How to find quickstart templates.<br>- Use a policy module to help you use Azure to develop for Azure Stack Hub. | [Develop for Azure Stack Hub](azure-stack-developer.md) |
| Review and follow the best practices for templates. | [Resource Manager Quickstart Templates](https://github.com/Azure/azure-quickstart-templates/blob/master/1-CONTRIBUTION-GUIDE/best-practices.md)
| | |

## Version requirements

Azure Stack Hub supports specific versions of Azure PowerShell and Azure service APIs. Use supported versions to ensure that your app can deploy to both Azure Stack Hub and to Azure.

To make sure that you use a correct version of Azure PowerShell, use [API version profiles](azure-stack-version-profiles.md). To determine the latest API version profile that you can use, find out the build of Azure Stack Hub you're using. You can get this information from your Azure Stack Hub administrator.

> [!NOTE]
> If you're using the Azure Stack Development Kit, and you have administrative access, see the [Determine the current version](../operator/azure-stack-updates.md) section to determine the Azure Stack Hub build.

For other APIs, run the following PowerShell command to output the namespaces, resource types, and API versions that are supported in your Azure Stack Hub subscription (there may still be differences at a property level). For this command to work, you must have already [installed](../operator/azure-stack-powershell-install.md) and [configured](azure-stack-powershell-configure-user.md) PowerShell for an Azure Stack Hub environment. You must also have a subscription to an Azure Stack Hub offer.

```powershell
Get-AzureRmResourceProvider | Select ProviderNamespace -Expand ResourceTypes | Select * -Expand ApiVersions | `
Select ProviderNamespace, ResourceTypeName, @{Name="ApiVersion"; Expression={$_}} 
```

Example output (truncated):
![Example output of Get-AzureRmResourceProvider command](media/azure-stack-considerations/image1.png)

## Next steps

For more detailed information about differences at a service level, see:

* [Considerations for VMs in Azure Stack Hub](azure-stack-vm-considerations.md)
* [Considerations for Storage in Azure Stack Hub](azure-stack-acs-differences.md)
* [Considerations for Azure Stack Hub networking](azure-stack-network-differences.md)
