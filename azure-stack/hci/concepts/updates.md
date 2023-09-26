---
title: Updates and upgrades
description: An overview of how updates and upgrades are applied to Azure Stack HCI.
author: jasongerend
ms.author: jgerend
ms.topic: conceptual
ms.date: 04/17/2023
---

# Updates and upgrades

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes the lifecycle of updates and upgrades on Azure Stack HCI. 

Azure Stack HCI solutions are designed to have a predictable update and upgrade experience:

- Microsoft releases monthly quality and security updates as well as annual feature updates to the Azure Stack HCI operating system.
- To keep your Azure Stack HCI service in a supported state, you have up to six months to install updates, but we recommend installing updates as they are released.
- Microsoft Hardware Solution Partners support Azure Stack HCI Integrated Systems or Validated Nodes with hardware service, support, and security updates for at least five years.

For information on the available updates for each version of Azure Stack HCI, see [Azure Stack HCI release information](../release-information.md).

:::image type="content" source="media/updates/lifecycle-versions.png" alt-text="Azure Stack HCI annual release roadmap" border="false":::

## Updating Azure Stack HCI

Updates to the Azure Stack HCI operating system are installed using Windows Admin Center, System Center, or PowerShell. The Cluster-Aware Updating feature orchestrates installing the updates on each server in the cluster so that your applications continue running during the upgrade.

> [!NOTE]
> Deploying annual feature updates by using Windows Server Update Services (WSUS) is currently not supported. You can use Windows Update or download the [Azure Stack HCI operating system ISO file](../deploy/download-azure-stack-hci-software.md) to perform a rolling cluster upgrade via Cluster-Aware Updating (CAU), or manually update each node.

:::image type="content" source="../manage/media/preview-channel/feature-updates.png" alt-text="Windows Admin Center showing a feature update ready to install." lightbox="../manage/media/preview-channel/feature-updates.png":::

Hardware partners and solution builders can plug into Windows Admin Center and develop extensions to keep the firmware, drivers, and BIOS of servers up-to-date and consistent across cluster nodes. Customers who purchase an integrated system with Azure Stack HCI pre-installed can install solution updates via these extensions; customers who simply purchase validated hardware nodes may need to perform the updates separately, according to the hardware vendor's recommendations.

Virtual machines also need to be updated regularly. In addition to Windows Update,  Windows Server Update Services, and System Center Virtual Machine Manager, you can use Azure Update Management to update VMs.

## Migrating to Azure Stack HCI

There are two ways to migrate existing Windows Server clusters to Azure Stack HCI:

- **[Using the same cluster](../deploy/migrate-cluster-same-hardware.md)** - This process performs a clean installation of the new Azure Stack HCI operating system and then imports your existing VMs, retaining your existing cluster settings and storage.
- **[Using a new cluster](../deploy/migrate-cluster-new-hardware.md)** - You can migrate virtual machine (VM) files on Windows Server 2019, Windows Server 2016, or Windows Server 2012 R2 to a new Azure Stack HCI cluster using Windows PowerShell and Robocopy.

## Cluster-Aware Updating

Updating a cluster requires orchestration because some updates require an operating system restart and servers must be restarted one at a time to ensure availability of the cluster. Cluster-Aware Updating (CAU) is Microsoft's default cluster orchestrator, allowing updates to be performed either through an integrated update experience in Windows Admin Center or manually via PowerShell commands. Cluster-Aware Updating is extensible to support partner plug-ins that retrieve firmware and driver updates.

## Next steps

For related information, see also:

- [Update Azure Stack HCI clusters](../manage/update-cluster.md)