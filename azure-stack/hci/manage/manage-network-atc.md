---
title: Manage host networking with Network ATC
description: This topic covers how to manage host networking for Azure Stack HCI.
author: v-dasis
ms.topic: how-to
ms.date: 10/19/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Manage host networking using Network ATC

> Applies to: Azure Stack HCI, version 21H2

This article discusses how to manage Network ATC after it has been deployed. Network ATC simplifies the deployment and network configuration management for Azure Stack HCI clusters. You use Windows PowerShell to manage Network ATC.

## Remove an intent

If you want to test various configurations on the same adapters, you may need to remove an intent. If you previously deployed and configured Network ATC on your system, you may need to reset the node so that the configuration can be deployed. To do this, copy and paste the following commands to remove all existing intents and their corresponding vSwitch:

```powershell
    $intents = Get-NetIntent
    foreach ($intent in $intents)
    {
        Remove-NetIntent -Name $intent.IntentName
        Remove-VMSwitch -Name "*$($intent.IntentName)*" -ErrorAction SilentlyContinue -Force
    }
    
    Get-NetQosTrafficClass | Remove-NetQosTrafficClass
    Get-NetQosPolicy | Remove-NetQosPolicy -Confirm:$false
    Get-NetQosFlowControl | Disable-NetQosFlowControl
```

## Add a server node

You can add nodes to a cluster. Each node in the cluster receives the same intent, improving the reliability of the cluster. The new server node must meet all requirements as listed in the Requirements and best practices section of [Host networking with Network ATC](../deploy/network-atc.md).

In this task, you will add additional nodes to the cluster and observe how a consistent networking configuration is enforced across all nodes in the cluster.

1. Use the `Add-ClusterNode` cmdlet to add the additional (unconfigured) nodes to the cluster. You only need management access to the cluster at this time. Each node in the cluster should have all pNICs named the same.

    ```powershell
    Add-ClusterNode -Cluster HCI01
    Get-ClusterNode
    ```

1. Check the status across all cluster nodes using the `-ClusterName` parameter.

    ```powershell
    Get-NetIntentStatus -ClusterName HCI01
    ```

    > [!NOTE]
    > If pNICs do not exist on one of the additional nodes, `Get-NetIntentStatus` will report the error 'PhysicalAdapterNotFound', which easily identifies the provisioning issue.

1. Check the provisioning status of all nodes using `Get-NetIntentStatus`. The cmdlet reports the configuration for both nodes. Note that this may take a similar amount of time to provision as the original node.

    ```powershell
    Get-NetIntentStatus -ClusterName HCI01
    ```

You can also add several nodes to the cluster at once.

## Post-deployment tasks

There are several tasks to complete following a Network ATC deployment, including the following:

### Add non-APIPA addresses to storage adapters

This can be accomplished using DHCP on the storage VLANs or by using the `NetIPAddress` cmdlets.

### Set SMB bandwidth limits

If live migration uses SMB Direct (RDMA), configure a bandwidth limit to ensure that live migration does not consume all the bandwidth used by Storage Spaces Direct and Failover Clustering.

### Stretched cluster configuration

Stretched clusters require additional configuration that must be manually performed following the successful deployment of an intent. For stretched clusters, all nodes in the cluster must use the same intent.

## Next steps

- Learn more about [Stretched clusters](../concepts/stretched-clusters.md).
