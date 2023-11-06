---
title: What's new in Azure Stack HCI, version 23H2 preview release
description: Find out what's new in Azure Stack HCI, version 23H2 preview release
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/05/2023
---

# What's new in Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article lists the various features and improvements that are available in Azure Stack HCI, version 23H2.

Azure Stack HCI, version 23H2 is the latest version of the Azure Stack HCI solution that focuses on one integrated package, cloud-based deployment and updates, cloud-based monitoring and capacity management, Azure consistent CLI for Arc VM management, support for VM extensions, and more.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]


## Azure Stack HCI, version 23H2

The following sections briefly describe the various features and enhancements in Azure Stack HCI, version 23H2.

### One integrated package

Unlike the prior years, Azure Stack HCI, version 23H2 includes more than just the operating system (OS). There is a single package containing 23H2 operating system, the orchestrator, Arc VM management and AKS hybrid software bits. The 23H2 operating system includes the latest cumulative update corresponding to September 2023.

### Cloud-based deployment

Starting this release, you can deploy and register an Azure Stack HCI cluster via the Azure portal.

For more information, see [Deploy Azure Stack HCI cluster using the Azure portal](./index.yml).

### Cloud-based updates

This new release has the infrastructure to group all the applicable updates for the OS, software agents, Azure Arc infrastructure and even OEM drivers and firmware into a single monthly update package. Additionally, the natively integrated Azure Update Manager tool proactively checks for and applies updates via the cloud.  

For more information, see [Update your Azure Stack HCI cluster via the Azure Update Manager](./update/update-azure-stack-hci-solution.md).​

### Capacity management

In this release, you can add and remove servers, or repair servers from your Azure Stack HCI system via the PowerShell.

For more information, see [Add server](./manage/add-server.md) and [Repair server](./manage/repair-server.md).

### Support for Azure VM extensions on Arc VMs on Azure Stack HCI

Starting with this preview release, you can also enable and manage all Azure VM extensions supported on Azure Arc VMs created via the Azure CLI. You can manage these VM extensions using the Azure CLI or the Azure portal.

For more information, see [Manage VM extensions for Azure Stack HCI VMs](./manage/virtual-machine-manage-extension.md).

### New Azure Consistent CLI

Beginning this preview release, a new Azure CLI `stack-hci-vm` module is available. The command line experience to create VM and VM resources such as VM images, storage paths, logical networks, and network interfaces on Azure Stack HCI has changed.

For more information, see [Create Arc VMs on Azure Stack HCI](./manage/create-arc-virtual-machines.md).

### Trusted VM launch

Azure Trusted Launch protects VMs against boot kits, rootkits, and kernel-level malware. Starting this preview release, some of those Trusted Launch capabilities are available for Arc VMs on Azure Stack HCI.

For more information, see [Trusted launch for Arc VMs](./index.yml).

### Health alerts

This release integrates the Azure Monitor alerts with Azure Stack HCI so that any health alerts generated within your on-premises Azure Stack HCI system are automatically forwarded to Azure Monitor alerts. You can link these alerts with your automated incident management systems, ensuring timely and efficient response.

For more information, see [Respond to Azure Stack HCI health alerts using Azure Monitor alerts](./manage/health-alerts-via-azure-monitor-alerts.md).

### ReFS deduplication and compression
 
This release introduces the Resilient File System (ReFS) deduplication and compression feature designed specifically for active workloads, such as Azure Virtual Desktop (AVD) on Azure Stack HCI. Enable this feature using Windows Admin Center or PowerShell to optimize storage usage and reduce cost. For more information, see [Optimize storage with ReFS deduplication and compression in Azure Stack HCI](./manage/refs-deduplication-and-compression.md).

### Enhanced monitoring capabilities with Insights
 
With Insights for Azure Stack HCI, you can now monitor and analyze performance, savings, and usage insights about key Azure Stack HCI features, such as ReFS deduplication and compression. To use these enhanced monitoring capabilities, ensure that your cluster is deployed, registered, and connected to Azure, and enrolled in monitoring. For more information, see [Monitor Azure Stack HCI features with Insights](./index.yml).


## Next steps

- [Read the blog about What’s new for Azure Stack HCI at Microsoft Ignite 2023](https://aka.ms/hci-ignite-blog).
- For Azure Stack HCI, version 23H2 deployments:
    - Read the [Deployment overview](./deploy/deployment-introduction.md).
    - Learn how to [Deploy via Azure portal](./deploy/deploy-via-portal.md) using the Azure Stack HCI, version 23H2.
