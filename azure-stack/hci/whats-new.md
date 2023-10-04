---
title: What's new in Azure Stack HCI, version 23H2 preview release
description: Find out what's new in Azure Stack HCI, version 23H2 preview release
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/03/2023
---

# What's new in Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-supplemental-package-22h2](../includes/hci-applies-to-23h2-21h2.md)]

This article lists the various features and improvements that are available in Azure Stack HCI, version 23H2.

Azure Stack HCI, version 23H2 is the latest version of the Azure Stack HCI solution that focuses on one integrated package, cloud-based deployment, updates and capacity management, Azure consistent CLI for Arc VM management, support for VM extensions, and more.

<!--You can also join the Azure Stack HCI preview channel to test out features for future versions of the Azure Stack HCI operating system. For more information, see [Join the Azure Stack HCI preview channel](./manage/preview-channel.md).-->

The following sections briefly describe the various features and enhancements in [Azure Stack HCI, version 23H2](#azure-stack-hci-version-23h2).


[!INCLUDE [hci-preview](../includes/hci-preview.md)]


## Azure Stack HCI, version 23H2

The following sections briefly describe the various features and enhancements in Azure Stack HCI, version 23H2.

### One integrated package

Unlike the prior years, Azure Stack HCI, version 23H2 includes more than just the operating system (OS). There is a single package containing 23H2 operating system, the orchestrator, Arc VM management and AKS hybrid software bits. The 23H2 operating system includes the latest cumulative update corresponding to September 2023.

### Cloud-based deployment

Starting this release, you can deploy and register an Azure Stack HCI cluster via the Azure portal.

For more information, see [Deploy Azure Stack HCI cluster using the Azure portal](./index.yml).

### Cloud-based updates

You can also apply software updates to your cluster via the Azure Update Manager in the Azure portal. 

For more information, see [Update your Azure Stack HCI cluster via the Azure Update Manager](./index.yml).​

### Manage cluster capacity

In this release, you can add or remove nodes from your Azure Stack HCI cluster using the Azure portal.

For more information, see [Manage cluster capacity using the Azure portal](./index.yml).

### Support for Azure VM extensions 

Starting with this preview release, you can also enable and manage all Azure VM extensions supported on Azure Arc-enabled servers for VMs created via the Azure CLI. You can manage VM extensions on your Azure Stack HCI VMs using the Azure CLI or the Azure portal.

For more information, see [Manage VM extensions for Azure Stack HCI VMs](./index.yml).

### New Azure Consistent CLI

Beginning this preview release, a new Azure CLI module is available and the command line experience to create VM and VM resources on Azure Stack HCI has changes.

For more information, see [Deploy Arc VMs on Azure Stack HCI](./index.yml).

### Trusted VM launch

Microsoft Azure Trusted Launch protects VMs against boot kits, rootkits, and kernel-level malware. Starting this preview release, some of those Trusted Launch capabilities are available for Arc VMs on Azure Stack HCI.

For more information, see [Trusted launch for Arc VMs](./index.yml).

## Issues fixed

|Release version|Feature|Issue|
|-|------|------|
|2310|Security |In this release, when you run `Get-AsWDACPolicy` cmdlet on a two-node Azure Stack HCI cluster, the cmdlet returns `Unable to determine` as opposed to an integer (0, 1 or 2). |
|2310|Azure Arc|After update, the Azure Stack HCI cluster servers show as not registered with Azure Arc.|To mitigate this issue, follow these steps: <br> 1. *Azcmamnet.exe* connect on each **Not registered** server <br>2. Register the servers again. Run this cmdlet on each server that isn't register <br>`Register-AzStackHCI`   |
|2310|Arc Resource Bridge  |In this release, a custom location isn't created during Arc Resource Bridge deployment.|

## Next steps

- [Read the blog about What’s new for Azure Stack HCI at Microsoft Ignite 2023](https://aka.ms/hci-ignite-blog).
- For existing Azure Stack HCI deployments, [Update Azure Stack HCI](./manage/update-cluster.md).
- For new Azure Stack HCI deployments:
    - Read the [Deployment overview](./index.yml).
    - Learn how to [Deploy via Azure portal](./index.yml) using the Azure Stack HCI, version 23H2.
