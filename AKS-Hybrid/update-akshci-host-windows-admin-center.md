---
title: Concepts - Updating Azure Kubernetes Service host in AKS hybrid using Windows Admin Center
description: Learn about using Windows Admin Center to update the Azure Kubernetes Service host in AKS hybrid.
ms.topic: conceptual
ms.date: 11/07/2022
ms.custom: fasttrack-edit
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: sethmanheim

# Intent: As an IT Pro, I need to understand how to use Windows Admin Center to update my AKS  host.
# Keyword: auto-update Windows Admin Center
---

# Upgrade the Azure Kubernetes Service host in AKS hybrid using Windows Admin Center

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to upgrade the Azure Kubernetes Service (AKS) host core system to the latest version in AKS hybrid. 

## Overview of AKS host updates

Several types of updates can be made independently or in certain supported combinations:

- Update the AKS hybrid core system to the latest version.
- Update an AKS workload cluster to a new Kubernetes version.
- Update the container hosts of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.

To avoid outages and loss of AKS availability, rolling updates are performed.

When you bring a new node with a newer build into the cluster, resources move from the old node to the new node, and when the resources are successfully moved, the old node is decommissioned and removed from the cluster.

We recommend that you update workload clusters immediately after updating the AKS host to prevent running unsupported container host OS versions or Kubernetes versions in your workload clusters. If your workload clusters are on an old Kubernetes version, they are still supported, but you will not be able to scale your cluster.

> [!NOTE]  
> Microsoft recommends upgrading your AKS hybrid clusters within 30 days of a new release. If you do not update within this window, you have up to 90 days from your last upgrade before internal certificates and tokens expire. Once the certificates and tokens expired the cluster is still functional; however, you must call Microsoft Support to upgrade. When you reboot the cluster after the 90-day period, it remains in a non-functional state. For more information about internal certificates and tokens, see [Certificates and tokens](/azure-stack/aks-hci/certificates-update-after-sixty-days).

## Update the AKS host

To update the AKS host by using Windows Admin Center, follow these steps:

1. Update your Azure Kubernetes Service extension by navigating to **Settings** > **Extensions** > **Installed Extensions**, and then click **Update**. The latest available Azure Kubernetes Service extension version is 1.82.0. You do not need to complete this step if you have enabled auto-update for your extensions. However, make sure that you have version 1.82.0 of the AKS extension installed before proceeding to the next step.

2. On the **Host settings** page, select **Update AksHci PowerShell module to version x.x.x** under **Updates available**, and then click **Update now**.

   [ ![Screenshot showing the available AksHci PowerShell updates in AKS host settings.](./media/wac-upgrade/available-module-version.png) ](./media/wac-upgrade/available-module-version.png#lightbox)

4. You can now go back to the Windows Admin Center **Connections** page and connect to your AKS cluster.
5. Select the **Azure Kubernetes Service** tool from the **Tools** list. When the tool loads, the **Overview** page is displayed.
6. Select **Updates** from the page list on the left side of the tool, and then select **Update now** to upgrade your AKS host.

> [!NOTE]
> - The update might stall if you navigate away from the update window while it's in progress.
> - During the update process, if you receive an error that says **Could not install updates****, the current deployment cannot be updated to the latest version. To work around this error, run `Get-AksHciUpdates` in PowerShell and review the recommendations provided in the output.

## Next steps
- [Update the Kubernetes version of your workload clusters](./upgrade-kubernetes.md)