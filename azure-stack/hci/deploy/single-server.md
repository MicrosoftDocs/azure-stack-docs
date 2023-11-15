---
title:  Deploy Azure Stack HCI on a single server
description: This article describes Azure Stack HCI OS configuration on a single server
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: kimlam
ms.lastreviewed: 01/17/2023
ms.date: 09/29/2023
---

# Deploy Azure Stack HCI on a single server

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to use PowerShell to deploy Azure Stack HCI on a single server that contains all NVMe or SSD drives, creating a single-node cluster. It also describes how to add servers to the cluster (scale-out) later.

Currently you can't use Windows Admin Center to deploy Azure Stack HCI on a single server. For more info, see [Using Azure Stack HCI on a single server](../concepts/single-server-clusters.md).

## Prerequisites

- A server from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog) that's certified for use as a single-node cluster and configured with all NVMe or all SSD drives.
- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optionally, [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) to register and manage the server once it has been deployed.

## Deploy on a single server

Here are the steps to install the Azure Stack HCI OS on a single server, create the single-node cluster, register the cluster with Azure, and create volumes.

1. Connect to the server by opening a PowerShell session:

    ```powershell
    Enter-PSSession -ComputerName <server-name>
    ```

1. Install the Azure Stack HCI OS on your server. For more information, see [Deploy the Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment) onto your server.
1. Configure the server utilizing the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
1. Install the required roles and features using the following command, then reboot before continuing.

   ```powershell
   Install-WindowsFeature -Name "BitLocker", "Data-Center-Bridging", "Failover-Clustering", "FS-FileServer", "FS-Data-Deduplication", "Hyper-V", "Hyper-V-PowerShell", "RSAT-AD-Powershell", "RSAT-Clustering-PowerShell", "NetworkATC", "Storage-Replica", "NetworkHUD" -IncludeAllSubFeature -IncludeManagementTools
   ```

1. Use PowerShell to [create a cluster](../deploy/create-cluster-powershell.md), skipping creating a cluster witness.

   Here's an example of creating the cluster and then enabling Storage Spaces Direct while disabling the storage cache:

   ```powershell
   $ClusterName= "<Name to use when accessing this system - 15 characters or less>"
   $ServerName= "<Current name of the server>"
   ```

   ```powershell
   New-Cluster -Name $ClusterName -Node $ServerName -nostorage
   Enable-ClusterStorageSpacesDirect -CacheState Disabled
   ```

   > [!NOTE]
   > - The cluster name should not exceed 15 characters.
   > - The `New-Cluster` command will also require the `StaticAddress` parameter if the node is not using DHCP for its IP address assignment.  This parameter should be supplied with a new, available IP address on the node's subnet.

1. Use [PowerShell](../deploy/register-with-azure.md?tab=power-shell#register-a-cluster) or [Windows Admin Center](../deploy/register-with-azure.md?tab=windows-admin-center#register-a-cluster) to register the cluster.
1. [Create volumes](../manage/create-volumes.md).

## Updating single-node clusters

To install updates for Azure Stack HCI version 21H2, use Windows Admin Center (Server Manager > Updates), [PowerShell](../manage/update-cluster.md#update-a-cluster-using-powershell), or connect via Remote Desktop and use [Server Configuration tool (SConfig)](../manage/update-cluster.md#perform-a-manual-feature-update-of-a-failover-cluster-using-sconfig).

To install updates for Azure Stack HCI version 22H2, use Windows Admin Center (Cluster Manager > Updates). Cluster Aware Updating (CAU) is supported beginning with this version. To use PowerShell or connect via Remote Desktop and use Server Configuration Tool (SConfig), see [Update Azure Stack HCI clusters](../manage/update-cluster.md).

For solution updates (such as driver and firmware updates), see your solution vendor.

## Change a single-node to a multi-node cluster (optional)

You can add servers to your single-node cluster, also known as scaling out, though there are some manual steps you must take to properly configure Storage Spaces Direct fault domains (`FaultDomainAwarenessDefault`) in the process. These steps aren't present when adding servers to clusters with two or more servers.

1. Validate the cluster by specifying the existing server and the new server: [Validate an Azure Stack HCI cluster - Azure Stack HCI | Microsoft Docs](../deploy/validate.md).
2. If cluster validation was successful, add the new server to the cluster: [Add or remove servers for an Azure Stack HCI cluster - Azure Stack HCI | Microsoft Docs](../manage/add-cluster.md).
3. Once the server is added, change the cluster's fault domain awareness from PhysicalDisk to ScaleScaleUnit: [Inline fault domain changes](../manage/single-node-scale-out.md#inline-fault-domain-changes).
4. Optionally, if more resiliency is needed, adjust the volume resiliency type from a 2-way mirror to a Nested 2-way mirror: [Single-server to two-node cluster](../manage/single-node-scale-out.md#single-server-to-two-node-cluster).
5. [Set up a cluster witness](../manage/witness.md).

## Next steps

- [Deploy workload – AVD](../deploy/virtual-desktop-infrastructure.md)
- [Deploy workload – AKS-HCI](/azure-stack/aks-hci/overview)
- [Deploy workload – Azure Arc-enabled data services](/azure/azure-arc/data/overview)
