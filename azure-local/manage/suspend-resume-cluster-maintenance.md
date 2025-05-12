---
title: Suspend and resume Azure Local, version 23H2 machines for planned maintenance operations
description: Learn how to suspend and resume machines for planned maintenance operations.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.custom:
  - devx-track-azurecli
ms.date: 04/23/2025
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully suspend and resume their machines for planned maintenance.
---

# Suspend and resume Azure Local machines for maintenance

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to suspend an Azure Local machine for planned maintenance, such as powering off the machine to replace non-hot-pluggable components. It also provides instructions on how to resume the machine once maintenance is complete. 

## Suspend a machine

To suspend a machine, first suspend the machine in Windows Failover Clustering. You can use various tools for this step, such as Windows Admin Center, Failover Cluster Manager, or PowerShell. We recommend using PowerShell as some steps can only be performed using that tool.

To suspend a machine, follow these steps:

1. Sign in to one of the machines with a user that has local administrator permissions.
1. To suspend the machine, run this command:

    ```powershell
    Suspend-Clusternode -name “MachineName” -drain
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Suspend-Clusternode -name ASRRlS3lRl5ull -drain

    Name               State      Type
    ----               -----      ----
    ASRRls3lRl5ull     Paused     Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the machine is successfully suspended.

    ```powershell
    Get-Clusternode
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Get-Clusternode

    Name                State        Type
    ----                -----        ----
    ASRRlS3lRl5u09      Up           Node
    ASRRlS3lRl5Ull      Paused       Node
    ```

1. To ensure that no new VMs are placed on the node, remove the node from the active Azure Local VM Configuration. **This step can only be done using PowerShell**.

    ```powershell
    Remove-MocPhysicalNode -nodeName “MachineName”
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Remove-MocPhysicalNode -nodename ASRRlS3lRl5Ull
    ```

## Resume a machine

To resume a machine, first resume the machine in Windows Failover Clustering. You can use various tools for this step, such as Windows Admin Center, Failover Cluster Manager, or PowerShell. We recommend using PowerShell as some steps can only be performed using that tool.

To resume a machine, follow these steps:

1. Sign in to one of the machines with a user that has local administrator permissions.
1. To resume the machine, run this command:

    ```powershell
    Resume-Clusternode -name “MachineName” 
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Resume-Clusternode -name ASRRlS3lRl5ull

    Name               State      Type
    ----               -----      ----
    ASRRls3lRl5ull     Up         Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the machine is successfully resumed.

    ```powershell
    Get-Clusternode
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Get-Clusternode

    Name                State        Type
    ----                -----        ----
    ASRRlS3lRl5u09      Up           Node
    ASRRlS3lRl5Ull      Up           Node
    ```

1. Add the machine to the active Azure Local VM Configuration. **This step can only be done using PowerShell**.

    ```powershell
    New-MocPhysicalNode -nodeName “MachineName”
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> New-MocPhysicalNode -nodename ASRRlS3lRl5ull
    
    ElementName     : HV Socket Agent Communication
    PSPath          : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL MACHINE\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Virtualization\GuestCommunicationServices\00000001-facb-lle6-b
    d58-64006a7986d3
    PSParentPath    : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersions\Virtualization\GuestCommunicationServices
    PSChildName     : 00000001-facb-lle6-bd58-64006a7986d3
    PSDrive         : HKLM
    PSProvider      : Microsoft.PowerShell.Core\Registry
    PSComputerName  : ASRRlS3lRl5ull
    RunspaceId      : 05c0eaad-0747-4912-a6e9-el09d975c444

    True
    ```

1. Verify that your storage pool is healthy.

    ```powershell
    Get-Storagepool -friendlyname “SU_Pool1”
    ```

    Here's example output:

    ```console
    PS C : \programdata\wssdagent> Get-Storagepool -friendlyname "SU1_Pool"

    FriendlyName     Operationalstatus     HealthStatus     IsPrimordial     IsReadOnly     Size     AllocatedSize 
    ------------     -----------------     ------------     ------------     ----------     ----     -------------
    SUl_Pool         OK                    Healthy          False            False     131.28 TB           1.8S TB
    ```

    > [!NOTE]
    > If the pool is not reported as healthy, check the status of the storage repair jobs using the `get-storagejob` command.
