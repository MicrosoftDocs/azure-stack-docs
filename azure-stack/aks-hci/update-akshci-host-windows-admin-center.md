---
title: Concepts - Updating Azure Kubernetes Services on Azure Stack HCI host using Windows Admin Center
description: Learn about using Windows Admin Center to update the Azure Kubernetes Service on Azure Stack HCI host.
ms.topic: conceptual
ms.date: 09/08/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---

# Upgrade the AKS on Azure Stack HCI host using Windows Admin Center

This article describes how to upgrade the AKS on Azure Stack HCI core system to the latest version. For information on updating an AKS workload cluster, see [update the Kubernetes version of AKS clusters](./upgrade.md).

> [!Note]
> When an AKS on Azure Stack HCI cluster is not upgraded within 60 days, the KMS plug-in token and certificates both expire within the 60 days. The cluster is still functional, however since it's beyond 60 days, you need to call support to upgrade. If the cluster is rebooted after this period, it will continue to remain in the same non-functional state.

There are several types of updates, which can happen independently from each other and in certain supported combinations:

- Update the AKS on Azure Stack HCI core system to the latest version.
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the container hosts of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.

All updates are done in a rolling update flow to avoid outages in  AKS on Azure Stack HCI availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node, and when the resources are successfully moved, the _old_ node is decommissioned and removed from the cluster.

We recommend that you update workload clusters immediately after updating the AKS host to prevent running unsupported container host OS versions or Kubernetes versions in your workload clusters. If your workload clusters are on an old Kubernetes version, they are still supported, but you will not be able to scale your cluster. 

## Update the AKS on Azure Stack HCI host

To update the AKS on Azure Stack HCI host with Windows Admin Center, follow the steps below: 

1. Update your Azure Kubernetes Service extension by navigating to **Settings** > **Extensions** > **Installed Extensions**, and then click **Update**. The latest available Azure Kubernetes Service extension version is 1.82.0. You do not need to complete this step if you have enabled auto-update for your extensions. However, make sure that you have version 1.82.0 of the AKS extension installed before proceeding to the next step.

2. On the **Host settings** page, select **Update AksHci PowerShell module to version x.x.x** under **Updates available**, and then click **Update now**.
   
   [ ![Displays the available AksHci PowerShell updates.](.\media\wac-upgrade\available-module-version.png) ](\media\wac-upgrade\available-module-version.png#lightbox)
   
4. You can now go back to the Windows Admin Center **Connections** page and connect to your Azure Stack HCI cluster.
5. Select the **Azure Kubernetes Service** tool from the **Tools** list. When the tool loads, you will see with the **Overview** page.
6. Select **Updates** from the page list on the left side of the tool, and then select **Update now** to upgrade your AKS host.

> [!NOTE]
> - The update process may stall if you navigate away from the update window when updating AKS on Azure Stack HCI.
> - During the update process, if you receive an error that says _Could not install updates_, the current deployment cannot update to the latest version. To work around this error, run `Get-AksHciUpdates` in PowerShell and review the recommendations provided in the output.

## Next steps
[Update Kubernetes version of your workload clusters](./upgrade-kubernetes.md)
