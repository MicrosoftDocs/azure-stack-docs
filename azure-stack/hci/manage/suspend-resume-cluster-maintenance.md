---
title: Suspend and resume Azure Stack HCI, version 23H2 clusters for planned maintenance operations
description: Learn how to suspend and resume cluster nodes for planned maintenance operations.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 09/17/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully suspend and resume their cluster nodes for planned maintenance.
---

# Suspend and resume Azure Stack HCI, version 23H2 clusters for maintenance

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to suspend a cluster node for planned maintenance, such as powering off the machine to replace non-hot-pluggable components. It also provides instructions on how to resume the cluster node once maintenance is complete. 

## Suspend a cluster node

To suspend a cluster node, first suspend the cluster node in Windows Failover Clustering. You can use various tools for this step, such as Windows Admin Center, Failover Cluster Manager, or PowerShell. We recommend using PowerShell as some steps can only be performed using that tool.

To suspend a cluster node, follow these steps:

1. Log on to one of the cluster nodes with a user that has local administrator permissions.
1. To suspend the cluster node, run this command:

    ```powershell
    Suspend-clusternode -name “MachineName” -drain
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Suspend-ClusterNode ASRRlS3lRl5ull

    Name               State      Type
    ----               -----      ----
    ASRRls3lRl5ull     Paused     Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the node is successfully suspended.

    ```powershell
    Get-clusternode
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> get-clusternode

    Name                State        Type
    ----                -----        ----
    ASRRlS3lRl5u09      Up           Node
    ASRRlS3lRl5Ull      Paused       Node
    ```

1. To ensure that no new VMs are placed on the node, remove the node from the active Arc VM Configuration. **This step can only be done using PowerShell**.

    ```powershell
    Remove-MocPhysicalNode -nodeName “MachineName”
    ```

## Resume a cluster node

To resume a cluster node, first resume the cluster node in Windows Failover Clustering. You can use various tools for this step, such as Windows Admin Center, Failover Cluster Manager, or PowerShell. We recommend using PowerShell as some steps can only be performed using that tool.

To resume a cluster node, follow these steps:

1. Log on to one of the cluster nodes with a user that has local administrator permissions.
1. To resume the cluster node, run this command:

    ```powershell
    Resume-clusternode -name “MachineName” 
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Resume-ClusterNode ASRRlS3lRl5ull

    Name               State      Type
    ----               -----      ----
    ASRRls3lRl5ull     Up         Node
    ```

    > [!NOTE]
    > Running this command may take some time, depending on the number of VMs that need to be migrated.

1. Confirm that the node is successfully resumed.

    ```powershell
    Get-clusternode
    ```

    Here's example output:

    ```console
    PS C:\programdata\wssdagent> Get-clusternode

    Name                State        Type
    ----                -----        ----
    ASRRlS3lRl5u09      Up           Node
    ASRRlS3lRl5Ull      Paused       Node
    ```

1. Add the node to the active Arc VM Configuration. **This step can only be done using PowerShell**.

    ```powershell
    New-MocPhysicalNode -nodeName “MachineName”
    ```

1. Verify that your storage pool is healthy.

    ```powershell
    Get-Storagepool -friendlyname “SU_Pool1”
    ```

    Here's example output:

    ```console
    PS C : \programdata\wssdagent> get-storagepool -FriendlyName "SU1_Pool"

    FriendlyName     Operationalstatus     HealthStatus     IsPrimordial     IsReadOnly     Size     AllocatedSize 
    ------------     -----------------     ------------     ------------     ----------     ----     -------------
    SUl_Pool         OK                    Healthy          False            False     131.28 TB           1.8S TB
    ```

    > [!NOTE]
    > If the pool is not reported as healthy, check the status of the storage repair jobs using the `get-storagejob` command.
