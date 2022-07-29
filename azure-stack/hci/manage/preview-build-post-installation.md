---
title: Azure Stack HCI preview build post installation steps
description: How to update the cluster functional level and storage pool version to enable new features.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/29/2022
---

Applies to: Azure Stack HCI, version 22H2 preview

This article details how to update the cluster functional level and storage pool version after joining the preview channel and installing an Azure Stack HCI OS preview build.

## Post installation steps

Once the feature updates are installed, you'll need to update the cluster functional level and update the storage pool version using PowerShell in order to enable new features.

1. **Update the cluster functional level.**

   We recommend updating the cluster functional level as soon as possible. If you installed the feature updates with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox, you can skip this step.
   
   Run the following cmdlet on any server in the cluster:
   
   ```PowerShell
   Update-ClusterFunctionalLevel
   ```
   
   You'll see a warning that you cannot undo this operation. Confirm **Y** that you want to continue.
   
   > [!WARNING]
   > After you update the cluster functional level, you can't roll back to the previous operating system version.

2. **Update the storage pool.**
   
   After the cluster functional level has been updated, use the following cmdlet to update the storage pool. Run `Get-StoragePool` to find the FriendlyName for the storage pool representing your cluster. In this example, the FriendlyName is **S2D on hci-cluster1**:
   
   ```PowerShell
   Update-StoragePool -FriendlyName "S2D on hci-cluster1"
   ```
   
   You'll be asked to confirm the action. At this point, new cmdlets will be fully operational on any server in the cluster.

3. **Upgrade VM configuration levels (optional).**
   
   You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet, and then starting the VMs again.

4. **Verify that the upgraded cluster functions as expected.**
   
   Roles should fail-over correctly and if VM live migration is used on the cluster, VMs should successfully live migrate.

5. **Validate the cluster.**
   
   Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

## Next steps

For more information, see also:

- [Update Azure Stack HCI clusters](update-cluster.md)
