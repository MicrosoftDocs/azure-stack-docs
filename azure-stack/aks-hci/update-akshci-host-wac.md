---
title: Concepts - Updating Azure Kubernetes Services on Azure Stack HCI host using Windows Admin Center
description: Learn about using Windows Admin Center to update the Azure Kubernetes Service on Azure Stack HCI host.
ms.topic: conceptual
ms.date: 07/02/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---

# Update the AKS on Azure Stack HCI host using Windows Admin Center

There are several types of updates, which can happen independently from each other and in certain supported combinations.

- Update the AKS on Azure Stack HCI core system to the latest version.
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the container hosts of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.

All updates are done in a rolling update flow to avoid outages in workload availability. When a _new_ node with a newer build is brought into the cluster, resources are moved from the _old_ node to the _new_ node, and once this is completed successfully, the _old_ node is decommissioned and removed from the cluster.

This article describes how to update the AKS on Azure Stack HCI core system to the latest version. For information on updating an AKS workload cluster, visit [how to update Kubernetes version of AKS clusters](./upgrade.md).

It's recommended to update AKS workload clusters immediately after updating the AKS host to prevent running unsupported container host OS versions or Kubernetes versions in your AKS workload clusters. If your workload clusters are on an old Kubernetes version, they will still be supported but you will not be able to scale your cluster. 

## Update the AKS on Azure Stack HCI host using Windows Admin Center

The AKS on Azure Stack HCI host can also be updated through Windows Admin Center. To update the host, follow the steps below: 

1. Update your Azure Kubernetes Service extension by navigating to **Settings** > **Extensions** > **Installed Extensions** and then click **Update**. The latest available Azure Kubernetes Service extension version is 1.35.0. You do not need to do this step if you have enabled auto-update for your extensions. However, make sure that you have version 1.35.0 of the AKS extension installed before proceeding to the next step.

2. Users who have installed AKS on Azure Stack HCI using the GA release will see an error that says *Incompatible AksHci Module Version* in Windows Admin Center when they update the Windows Admin Center extension to the June release (1.35.0). 
   
   To use the June release, PowerShell version 1.0.2 is required, so users must manually run the following PowerShell command on all the nodes in their Azure Stack HCI cluster to get around this error. 

   ```powershell
   Update-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.0.2 -AcceptLicense –Force 
   ```

3. You can now go back to the Windows Admin Center **Connections** page and connect to your Azure Stack HCI cluster.
4. Select the **Azure Kubernetes Service** tool from the **Tools** list. When the tool loads, you will see with the **Overview** page.
5. Select **Updates** from the page list on the left side of the tool, and then select **Update now** to upgrade your AKS host.

## Next steps
[Update Kubernetes version and container host OS of your AKS workload clusters](./upgrade.md)
