---
title: Adjustable storage repair speed in Azure Stack HCI and Windows Server clusters
description: How to adjust storage repair speed in Azure Stack HCI and Windows Server clusters by using Windows Admin Center or PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/08/2021
---

# Adjustable storage repair speed in Azure Stack HCI and Windows Server

> Applies to: Azure Stack HCI, version 21H2; Windows Server 2022

User adjustable storage repair speed offers more control over the data resync process by allocating resources to either repair data copies (resiliency) or run active workloads (performance). This helps improve availability and allows you to service your clusters more flexibly and efficiently.

## Storage repair speed settings

The storage speed repair settings are:

| **Setting**          | **Queue depth** | **Resource allocation**              |
|:---------------------|:----------------|:-------------------------------------|
| Very low             | 1               | Most resources to active workloads   |
| Low                  | 2               | More resources to active workloads   |
| Medium (default)     | 4               | Balances workloads and repairs       |
| High                 | 8               | More resources to resync and repairs |
| Very high            | 16              | Most resources to resync and repairs |

**Very low** to **Low** settings will allocate more resources to active workloads, allowing the server to complete mission-critical tasks. Take caution when changing the setting to **Very low**, as this may impact the time it takes for storage to regain full resiliency. **High** to **Very high** settings will prioritize storage resync and repairs, allowing a patch and update cycle to complete faster. The default setting is **Medium**, which ensures a balance of workload and repair prioritization. It's recommended to keep the repair speed set to **Medium** in most cases, unless you have a good reason for prioritizing either resiliency or performance.

   > [!IMPORTANT]
   > When storage repair speed is set to **Very high**, active workloads and cluster performance can be impacted. Likewise, when repair speed is set to **Very low**, it will take more time for storage to regain full resiliency.

## Change storage repair speed using Windows Admin Center

To change the storage repair speed for a cluster by using Windows Admin Center:

:::image type="content" source="media/storage-repair-speed/change-storage-repair-speed.png" alt-text="You can change storage repair speeds in Cluster Manager > Settings > Storage Spaces and pools" lightbox="media/storage-repair-speed/change-storage-repair-speed.png":::

1. In **Cluster Manager**, select **Settings** from the lower left.
1. In the **Settings** pane, select **Storage Spaces and pools**.
1. Use the **Storage repair speed** dropdown to select the desired speed.
1. Optional: Review the caution text if selecting **Very low** or **Very high**.
1. Select **Save**.

## Change storage repair speed using PowerShell:

To check the current repair speed setting:

```PowerShell
Get-StorageSubSystem -FriendlyName <name of cluster subsystem> | ft FriendlyName,VirtualDiskRepairQueueDepth
```

To set the repair speed:

```PowerShell
Set-StorageSubSystem -FriendlyName <name of cluster subsystem> -VirtualDiskRepairQueueDepth <value>
```

## Next steps

For more information, see also:

- [Taking an Azure Stack HCI server offline for maintenance](maintain-servers.md)
