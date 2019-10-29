---
title: PowerShell in Azure Stack | Microsoft Docs
description: PowerShell in Azure Stack has a number of modules and contexts.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: powershell
ms.topic: article
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/02/2019

---

# Get started with PowerShell in Azure Stack

PowerShell is designed for managing and administering resources from the command line. You can use PowerShell when you want to build automated tools that use the Azure Resource Manager model. A PowerShell module can be defined as a set of PowerShell functions that are grouped to manage all aspects of a particular area. To work with Azure Stack, you need to juggle various sets of PowerShell cmdlets.

This article helps you orient yourself to the variety of PowerShell modules that are used in Azure Stack. When you use PowerShell in Azure Stack, you can interact with any of four sets of APIs, as shown in the following table:

| API | PowerShell reference | REST reference |
| --- | --- | --- |
| Global Azure Resource Manager | [Azure PowerShell modules](https://github.com/Azure/azure-powershell/blob/master/documentation/azure-powershell-modules.md) | [REST API browser](https://docs.microsoft.com/rest/api/) |
| Azure Stack Resource Manager | [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md) | [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md) |
| Azure Stack administrator endpoints | [Azure Stack admin module](https://docs.microsoft.com/powershell/azure/azure-stack/overview) | [REST API browser - Azure Stack](https://docs.microsoft.com/rest/api/?term=Azure%20Azure%20Stack%20Admin) |
| Azure Stack privileged endpoint | [Use the privileged endpoint in Azure Stack](../operator/azure-stack-privileged-endpoint.md) | |

Each interface contacts resource providers in global Azure or Azure Stack. Resource providers enable Azure capabilities. For example, the Azure Compute resource provider gives you programmatic access to the creation and management of virtual machines and their supporting resources.

Resource providers provide both functionality and controls for managing and configuring the resource. You can programmatically access the resource providers by using Azure Resource Manager. In turn, the interface provides a surface for PowerShell, the Azure CLI, and your own REST clients.

## Where to find Azure Stack PowerShell

The following block diagram shows the relationships between the sets of PowerShell modules. From your machine, you can load the PowerShell modules and manage both global Azure and Azure Stack.

![Azure Stack Powershell](media/azure-stack-powershell-overview/Azure-Stack-PowerShell.png)

### Global Azure

Azure PowerShell contains a set of cmdlets that use the current version of Azure Resource Manager for working with your Azure resources. Azure PowerShell uses the .NET Standard version, which means that you can use versions of PowerShell with Windows, macOS, and Linux. Azure PowerShell is also available on Azure Cloud Shell. For more information, see [Get started with Azure PowerShell](https://docs.microsoft.com/powershell/azure/get-started-azureps).

### Azure Stack Resource Manager

Azure Stack PowerShell provides a set of cmdlets that use previous versions of Azure Resource Manager. These cmdlets are compatible with the resource providers in Azure Stack. Each resource provider in Azure Stack uses an older version of the provider found in global Azure. To help you coordinate the version of each provider that's supported by Azure Stack, you can use API profiles. Azure Stack PowerShell uses PowerShell 5.1 and is available only on Windows. For more information, see [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md).

### Azure Stack administrator

Azure Stack exposes a set of resource providers to the cloud operator so that the operator can install and maintain Azure Stack. In global Azure, this interaction is abstracted from the user and handled behind the scenes as part of Azure. With Azure Stack, however, enterprises can support a private cloud. To do these tasks, the operator interacts with the Azure Stack Admin APIs. For more information, see [Install PowerShell for Azure Stack](../operator/azure-stack-powershell-install.md).

### Azure Stack privileged endpoint

For operator activities in Azure Stack, such as testing the installation and accessing logs, operators can interact with the privileged endpoint (PEP). The PEP is a pre-configured remote PowerShell console that gives operators enough access to do specific tasks. The endpoint uses PowerShell Just Enough Administration (JEA) to expose a restricted set of cmdlets. For more information, see [Use the privileged endpoint in Azure Stack](../operator/azure-stack-privileged-endpoint.md).

### Azure Stack Tools

Azure Stack makes scripts and additional cmdlets available in a GitHub repository, *AzureStack-Tools*. AzureStack-Tools hosts PowerShell modules for managing and deploying resources to Azure Stack. If you're planning to establish VPN connectivity, you can download these PowerShell modules to the Azure Stack Development Kit, or to a Windows-based external client. For more information, go to the [AzureStack-Tools](https://github.com/Azure/AzureStack-Tools) page.

## Work with PowerShell in Azure Stack

PowerShell provides a programmatic way to interact with Azure Resource Manager. You can work with an interactive command prompt or, if you're automating tasks, you can write scripts.

If you spend much time working with Azure Stack PowerShell, you'll find yourself installing and reinstalling the modules. If you're working with global Azure at the same time, this routine can be challenging, because you'll need to uninstall and reinstall your modules depending on your target. 

You can use Docker containers to isolate each version of PowerShell on your local machine. To use Docker containers so that you can switch from PowerShell module set to PowerShell module set, see [Use Docker to run PowerShell](azure-stack-powershell-user-docker.md).


## Next steps

- Read about [API profiles for PowerShell](azure-stack-version-profiles.md) in Azure Stack.
- Install [Azure Stack Powershell](../operator/azure-stack-powershell-install.md).
- Read about creating [Azure Resource Manager templates](azure-stack-develop-templates.md) for cloud consistency.
