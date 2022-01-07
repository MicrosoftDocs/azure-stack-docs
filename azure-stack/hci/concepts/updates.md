---
title: Updates and upgrades
description: An overview of how updates and upgrades are applied to Azure Stack HCI.
author: jasongerend
ms.author: jgerend
ms.topic: conceptual
ms.date: 01/03/2022
---

# Updates and upgrades

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Azure Stack HCI solutions are designed to have a predictable update and upgrade experience.

## Support period

You can expect hardware service, support, and security updates from Microsoft Hardware Solution Partner for at least five years.

Feature updates for Azure Stack HCI are released periodically to enhance the customer experience. To keep your Azure Stack HCI service in a supported state, you have up to six months to install updates, but we recommend installing updates as they are released. Microsoft provides monthly quality and security updates for each supported version of Azure Stack HCI and also provides yearly feature updates. For information on the available updates for each version of Azure Stack HCI, see [Azure Stack HCI release information](../release-information.md).

:::image type="content" source="media/updates/lifecycle-versions.png" alt-text="Azure Stack HCI annual release roadmap" border="false":::

## Updating Azure Stack HCI

Like Windows 10, Azure Stack HCI will always be kept up to date with monthly quality and security updates from Microsoft. You initiate the updates using Cluster-Aware Updating, as on Windows Server.

Hardware partners and solution builders can plug into Windows Admin Center and develop extensions to keep the firmware, drivers, and BIOS of servers up-to-date and consistent across cluster nodes. Customers who purchase an integrated system with Azure Stack HCI pre-installed can install solution updates via these extensions; customers who simply purchase validated hardware nodes may need to perform the updates separately, according to the hardware vendor's recommendations.

Virtual machines also need to be updated regularly. In addition to Windows Update and Windows Server Update Services, you can use Azure Update Management to update VMs.

## Upgrading to Azure Stack HCI

You can upgrade from Windows Server 2019 to Azure Stack HCI, but not seamlessly; there is no in-place upgrade at this time. Upgrading requires a maintenance window and a clean install on each server, rebuilding each node individually as part of a rolling cluster upgrade.

## Cluster-Aware Updating

Updating a cluster requires orchestration because some updates require an operating system restart and servers must be restarted one at a time to ensure availability of the cluster. Cluster-Aware Updating (CAU) is Microsoft's default cluster orchestrator, allowing updates to be performed either through an integrated update experience in Windows Admin Center or manually via PowerShell commands. Cluster-Aware Updating is extensible to support partner plug-ins that retrieve firmware and driver updates.

## Next steps

For related information, see also:

- [Update Azure Stack HCI clusters](../manage/update-cluster.md)
