---
title: Post-upgrade steps on Azure Stack HCI via PowerShell
description: Learn how to perform the post-upgrade tasks on your Azure Stack HCI cluster using PowerShell.
author: alkohli
ms.topic: how-to
ms.date: 08/13/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Perform the post operating system upgrade steps on your Azure Stack HCI via PowerShell

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to perform the post-OS upgrade tasks after you upgraded the Azure Stack HCI Operating System (OS) to new version. The post-upgrade tasks described in this article are required for the stability of the cluster.

Throughout this article, we refer to Azure Stack HCI, version 23H2 as the new version and Azure Stack HCI, version 22H2 as the old version.


## Complete prerequisites

Before you begin, make sure that:

- You successfully upgraded the OS to version 23H2 on your Azure Stack HCI cluster as per the instructions in one of the following docs:

    - [Upgrade to 23H2 OS via PowerShell](./upgrade-22h2-to-23h2-powershell.md).
    - [Upgrade to 23H2 OS via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md).
    - [Upgrade to 23H2 OS via other methods](./upgrade-22h2-to-23h2-other-methods.md).
    
- Make sure that all the nodes in your Azure Stack HCI cluster are healthy and show as **Online**.
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.

## Step 1: Connect to the Azure Stack HCI cluster

Follow these steps on your client to connect to one of the servers of your Azure Stack HCI cluster.

1. Run PowerShell as Administrator on the client that you're using to connect to your cluster.
2. Open a remote PowerShell session to a server on your Azure Stack HCI cluster. Run the following command and provide the credentials of your server when prompted:

   ```powershell
   $cred = Get-Credential
   Enter-PSSession -ComputerName "<Computer IP>" -Credential $cred 
   ```
   
   Here's a sample output:

   ```Console
   PS C:\Users\Administrator> $cred = Get-Credential
   
   cmdlet Get-Credential at command pipeline position 1
   Supply values for the following parameters:
   Credential
   PS C:\Users\Administrator> Enter-PSSession -ComputerName "100.100.100.10" -Credential $cred 
   [100.100.100.10]: PS C:\Users\Administrator\Documents>
   ```

## Step 2: Verify the status of upgrade

To make sure that the upgrade was complete and there's a new OS running on the cluster, run the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName <ClusterName>
```

Here's a sample output: <!--ASK-->

```output
RunId                   : <Run ID> 
RunStartTime            : 10/13/2019 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2019 1:35:49 PM 
} 
NodeResults             : { 
Node                     : NODE2 
Status                   : Succeeded 
ErrorRecordData          : 
NumberOfSucceededUpdates : 0 
NumberOfFailedUpdates    : 0 
InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
}
```

## Step 3: Perform the post-OS upgrade steps

Once the new OS is installed, you need to upgrade the cluster functional level and upgrade the storage pool version using PowerShell in order to enable new features.

> [!IMPORTANT]
> - Post-OS upgrade steps are essential for the stability and performance of your Azure Stack HCI cluster. Make sure to follow these steps after the OS upgrade.


1. Upgrade the cluster functional level.

   > [!WARNING]
   > After you upgrade the cluster functional level, you can't roll back to the previous operating system version.

   We recommend that you upgrade the cluster functional level as soon as possible. Skip this step if you installed the feature upgrades with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox.

   1. Run the following cmdlet on any server in the cluster:

      ```PowerShell
      Update-ClusterFunctionalLevel      
      ```

   1. You see a warning that you can't undo this operation. Confirm **Y** that you want to continue.

1. Upgrade the storage pool.

   1. After the cluster functional level is upgraded, use the following cmdlet to identify the `FriendlyName` of the storage pool representing your cluster.

      ```PowerShell
      Get-StoragePool
      ```

      In this example, the `FriendlyName` is **S2D on hci-cluster1**.

   1. Run the `Update-StoragePool` cmdlet to upgrade the storage pool version.

      ```PowerShell
       Update-StoragePool -FriendlyName "S2D on hci-cluster1"
      ```

   1. Confirm the action when prompted. At this point, new cmdlets are fully operational on any server in the cluster.

1. (Optional) Upgrade VM configuration levels. You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet and then starting the VMs again.

   1. Verify that the upgraded cluster functions as expected.

       Roles should fail over correctly and, if VM live migration is used on the cluster, VMs should successfully live migrate.

   1. Validate the cluster.

       Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

You're now ready to apply the solution upgrade.

## Next steps

- [Optional: Install and enable Network ATC on your cluster.](./install-enable-network-atc.md)
- [Learn how to assess the solution upgrade readiness.](./validate-solution-upgrade-readiness.md)
