---
title: Post-upgrade steps on Azure Local via PowerShell
description: Learn how to perform the post-upgrade tasks for Azure Local using PowerShell.
author: alkohli
ms.topic: how-to
ms.date: 03/10/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Perform post operating system upgrade steps on Azure Local via PowerShell

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to perform the post-OS upgrade tasks after you upgraded the operating system (OS) to the new version. The post-upgrade tasks described in this article are required for the stability of the Azure Local instance.

Throughout this article, we refer to Azure Local 2311.2 as the *new* version and Azure Local, version 22H2 as the *old* version.

## Complete prerequisites

Before you begin, make sure that:

- You successfully upgraded the OS to version 23H2 on Azure Local as per the instructions in one of the following docs:

   - [Upgrade to 23H2 OS via PowerShell](./upgrade-22h2-to-23h2-powershell.md).
   - [Upgrade to 23H2 OS via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md).
   - [Upgrade to 23H2 OS via other methods](./upgrade-22h2-to-23h2-other-methods.md).

- Make sure that all the machines in your system are healthy and show as **Online**.
- You have access to a client that can connect to your system. This client should be running PowerShell 5.0 or later.

## Step 1: Connect to your system

Follow these steps on your client to connect to one of the machines of your system.

1. Run PowerShell as Administrator on the client that you're using to connect to your system.
2. Open a remote PowerShell session to a machine on your system. Run the following command and provide the credentials of your machine when prompted:

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

To make sure that the upgrade was complete and there's a new OS running on your system, run the `Get-CauRun` cmdlet:

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

Once the new OS is installed, you need to upgrade the cluster functional level and the storage pool version using PowerShell to enable new features.

> [!IMPORTANT]
> - Post-OS upgrade steps are essential for the stability and performance of your system. Make sure to follow these steps after the OS upgrade.

1. Upgrade the cluster functional level.

   > [!WARNING]
   > After you upgrade the cluster functional level, you can't roll back to the previous operating system version.

   We recommend that you upgrade the cluster functional level as soon as possible. Skip this step if you installed the feature upgrades with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox.

   1. Run the following cmdlet on any machine in the system to check the current cluster functional level:

      ```PowerShell
      Write-Host "Cluster Functional Level = $((Get-Cluster).ClusterFunctionalLevel)"
      ```

   1. Run the following cmdlet on any machine in the system to update the current cluster functional level:

      ```powershell
      Update-ClusterFunctionalLevel -Verbose   
      ```

   1. You'll see a warning that you can't undo this operation. Confirm **Y** to continue.

   1. Run the following cmdlet to check the new or updated cluster functional level:

      ```powershell
      Write-Host "Cluster Functional Level = $((Get-Cluster).ClusterFunctionalLevel)"
      ```

1. Upgrade the storage pool.

   1. After upgrading the cluster functional level, use the following cmdlet to identify the `FriendlyName` of the storage pool representing your system.

      ```PowerShell
      Get-StoragePool | Where-Object -Property FriendlyName -ne "Primordial"
      ```

   1. Use the following cmdlet to update the storage pool. Use the pool name from the output of the previous step.

      ```PowerShell
      Update-StoragePool -FriendlyName "<name of the storage pool>" -Verbose
      ```

   1. Confirm the action when prompted. At this point, new cmdlets are fully operational on any machine in the system.

1. (Optional) Upgrade VM configuration levels. You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet and then starting the VMs again.

   1. Verify that the upgraded system functions as expected.

       Roles should fail over correctly and, if VM live migration is used on the system, VMs should successfully live migrate.

   1. Validate the system.

       Run the `Test-Cluster` cmdlet on one of the machines in the system and examine the *cluster validation* report.

1. Install the latest drivers from your hardware partner, as some drivers may revert to an older inbox driver version resulting in unexpected behaviors.  

<!--You're now ready to apply the solution upgrade.-->

## Next step

- Learn how to [configure Network ATC on Azure Local](./install-enable-network-atc.md).
