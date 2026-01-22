---
title: Suspend and resume Azure Local machines for planned maintenance operations
description: Learn how to suspend and resume Azure Local machines for planned maintenance operations.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.custom:
  - devx-track-azurecli
ms.date: 01/22/2026
ms.subservice: hyperconverged
---

# Suspend and resume Azure Local machines for maintenance

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to suspend an Azure Local machine (physical host) for planned maintenance, such as powering off the machine to replace non-hot-pluggable components. It also provides instructions on how to resume the machine once maintenance is complete.

## Prerequisites

Before you begin, ensure that you have the following prerequisites in place for both suspending and resuming an Azure Local machine:

1. You have access to Azure Local machines (clustered physical hosts) with local administrator privileges.
1. Make sure that the machines are running Azure Local version 2311.2 or later.
1. Make sure that the client used to connect to Azure Local has PowerShell installed on it. You can use various tools for this step, such as Windows Admin Center, Failover Cluster Manager, or PowerShell. We recommend using PowerShell as some steps can only be performed using that tool.
1. Make sure to suspend or resume the Azure Local machine (cluster node) in Windows Failover Clustering.

## Suspend a machine

To suspend a machine, follow these steps:

1. Sign in to one of the Azure Local machines of your instance as a local administrator.
1. Run PowerShell as an administrator. To suspend the machine, run this command:

    ```powershell
    Suspend-ClusterNode -Name "<MachineName>" -Drain
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> Suspend-ClusterNode -Name ASRRLS3LRL5U11 -Drain

    Name               State      Type
    ----               -----      ----
    ASRRLS3LRL5U11     Paused     Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the machine is successfully suspended.

    ```powershell
    Get-ClusterNode
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> Get-ClusterNode

    Name                State        Type
    ----                -----        ----
    ASRRLS3LRL5U09      Up           Node
    ASRRLS3LRL5U11      Paused       Node
    ```

1. To ensure that no new VMs are placed on the node, remove the node (cluster member) from the active Azure Local VM Configuration using the Azure Local–specific `Remove-MocPhysicalNode` cmdlet. **This step can only be done using PowerShell**.

    ```powershell
    Remove-MocPhysicalNode -NodeName "<MachineName>"
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> Remove-MocPhysicalNode -NodeName ASRRLS3LRL5U11
    ```

## Resume a machine

To resume a machine, follow these steps:

1. Sign in to one of the Azure Local machines of your instance as a local administrator.
1. Run PowerShell as an administrator. To resume the machine, run this command:

    ```powershell
    Resume-ClusterNode -Name "<MachineName>"
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> Resume-ClusterNode -Name ASRRLS3LRL5U11

    Name               State      Type
    ----               -----      ----
    ASRRLS3LRL5U11     Up         Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the machine is successfully resumed.

    ```powershell
    Get-ClusterNode
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> Get-ClusterNode

    Name                State        Type
    ----                -----        ----
    ASRRLS3LRL5U09      Up           Node
    ASRRLS3LRL5U11      Up           Node
    ```

1. Add the machine (cluster node) to the active Azure Local VM Configuration using the Azure Local–specific `New-MocPhysicalNode` cmdlet. **This step can only be done using PowerShell**.

    ```powershell
    New-MocPhysicalNode -NodeName "<MachineName>"
    ```

    Here's an example output:

    ```console
    PS C:\programdata\wssdagent> New-MocPhysicalNode -NodeName ASRRLS3LRL5U11
    
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
    Get-StoragePool -FriendlyName "<StoragePoolName>"
    ```

    Here's an example output:

    ```console
    PS C : \programdata\wssdagent> Get-StoragePool -FriendlyName "SU1_Pool"

    FriendlyName     Operationalstatus     HealthStatus     IsPrimordial     IsReadOnly     Size     AllocatedSize 
    ------------     -----------------     ------------     ------------     ----------     ----     -------------
    SU1_Pool         OK                    Healthy          False            False     131.28 TB           1.85 TB
    ```

    > [!NOTE]
    > If the pool is not reported as healthy, check the status of the storage repair jobs using the `Get-StorageJob` command.
