---
title: Manage Azure Stack HCI clusters using PowerShell
description: Learn how to manage clusters on Azure Stack HCI using PowerShell
author: JasonGerend
ms.topic: how-to
ms.date: 07/21/2020
ms.author: jgerend
ms.reviewer: stevenek
---

# Manage Azure Stack HCI clusters using PowerShell

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019

Windows PowerShell can be used to manage resources and configure features on your Azure Stack HCI clusters.

You manage clusters from a remote computer, rather than on a host server in a cluster. This remote computer is called the management computer.

> [!NOTE]
> When running PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the cluster you are managing. In addition, you will need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

For the complete reference documentation for managing clusters using PowerShell, see the [FailoverCluster reference](/powershell/module/failoverclusters/).

## Using Windows PowerShell

Windows PowerShell is used to perform all the tasks in this article. It is recommended that you pin the app to your taskbar for convenience.

If the following cmdlets aren't available in your PowerShell session, you may need to add the `Failover Cluster` Module for Windows PowerShell Feature, using the following PowerShell cmd: `Add-WindowsFeature RSAT-Clustering-PowerShell`.

> [!NOTE]
> Starting with Windows 10 October 2018 Update, RSAT is included as a set of "Features on Demand" right from Windows 10. Simply go to **Settings > Apps > Apps & features > Optional features > Add a feature > RSAT: Failover Clustering Tools**, and select **Install**. To see installation progress, click the Back button to view status on the "Manage optional features" page. The installed feature will persist across Windows 10 version upgrades.

## View cluster settings and resources

Gets information about a cluster named Cluster1:

```powershell
Get-Cluster -Name Cluster1
```
Gets information about one or more nodes, or servers, in Cluster1:

```powershell
Get-ClusterNode -Cluster Cluster1
```

To see which Windows features are installed on a cluster node, use the `Get-WindowsFeature` cmdlet. For example:

```powershell
Get-WindowsFeature -ComputerName Server1
```

To see network adapters and their properties such as Name, IPv4 addresses, and VLAN ID:

```powershell
Get-NetAdapter -CimSession Server1 | Where Status -Eq "Up" | Sort InterfaceAlias | Format-Table Name, InterfaceDescription, Status, LinkSpeed, VLANID, MacAddress
```

To see Hyper-V virtual switches and how physical network adapters are teamed:

```powershell
Get-VMSwitch -ComputerName Server1
```

To see host virtual network adapters:

```powershell
Get-VMNetworkAdapter -ComputerName Server1
```

To see whether Storage Spaces Direct is enabled:

```powershell
Get-CimSession -ComputerName Server1 | Get-ClusterStorageSpacesDirect
```

## Start or stop a cluster

Use the `Start-Cluster` and `Stop-Cluster` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Start-Cluster](/powershell/module/failoverclusters/start-cluster) and [Stop-Cluster](/powershell/module/failoverclusters/stop-cluster) reference documentation.

Starts the Cluster service on all server nodes of the cluster on which it is not yet started:

```powershell
Start-Cluster -Name Cluster1
```

This example stops the Cluster service on all nodes in the cluster named Cluster1, which will stop all services and applications configured in the cluster:

```powershell
Stop-Cluster -Name Cluster1
```

## Add or remove a server

Use the `Add-ClusterNode` and `Remove-ClusterNode` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Add-ClusterNode](/powershell/module/failoverclusters/add-clusternode) and [Remove-ClusterNode](/powershell/module/failoverclusters/remove-clusternode) reference documentation.

This example adds a server named Node4 to a cluster named Cluster1. Make sure the server is running and connected to the cluster network first.

```powershell
Add-ClusterNode -Cluster Cluster1 -Name Node4
```

This example removes the node named node4 from cluster Cluster1:

```powershell
Remove-ClusterNode -Cluster Cluster1 -Name Node4
```

>[!NOTE]
> If the node has been added to a single server, see these [manual steps](../deploy/single-server.md#adding-servers-to-a-single-server-cluster) to reconfigure Storage Spaces Direct.

## Setup the cluster witness

Use the `Set-ClusterQuorum` cmdlet to set quorum witness options for the cluster. For more examples and usage information, see the [Set-ClusterQuorum](/powershell/module/failoverclusters/set-clusterquorum) reference documentation.

This example changes the quorum configuration to use a cloud witness on cluster Cluster1:

```powershell
Set-ClusterQuorum -Cluster Cluster1 -CloudWitness
```

This example changes the quorum configuration to Node and File Share Majority on the cluster Cluster1, using the disk resource at \\fileserver\fsw for the file share witness.

```powershell
Set-ClusterQuorum -Cluster Cluster1 -NodeAndFileShareMajority \\fileserver\fsw
```

## Enable Storage Spaces Direct

Use the `Enable-ClusterStorageSpacesDirect` cmdlet to enable Storage Spaces Direct on the cluster. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](/powershell/module/failoverclusters/enable-clusterstoragespacesdirect) reference documentation.

This example enables Storage Spaces Direct on Server1:

```powershell
Enable-ClusterStorageSpacesDirect -CimSession Cluster1
```

## Configure a Hyper-V host

Use the `Set-VMHost` cmdlet to configure various Hyper-V host settings, such as VHD and VM paths, live migrations, storage migrations, authentication, NUMA spanning and others. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](/powershell/module/hyper-v/set-vmhost) reference documentation.

This example specifies new default locations for virtual hard disks and VMs on host server Server1:

```powershell
Set-VMHost -ComputerName Server1 -VirtualHardDiskPath "C:\Hyper-V\Virtual Hard Disks" -VirtualMachinePath "C:\Hyper-V\Configuration Files"
```

This example configures host server Server1 to allow 10 simultaneous live migrations and storage migrations:

```powershell
Set-VMHost -ComputerName Server1 -MaximumVirtualMachineMigrations 10 -MaximumStorageMigrations 10
```

This example configures host server Server1 to use Kerberos to authenticate incoming live migrations:

```powershell
Set-VMHost -ComputerName Server1 -VirtualMachineMigrationAuthenticationType Kerberos
```

## Remove a cluster

Before you remove (destroy) a cluster, you must unregister it from Azure first. For more information, see [Unregister Azure Stack HCI](manage-azure-registration.md#unregister-azure-stack-hci-by-using-powershell).

Use the `Remove-ClusterResource` cmdlet to remove one or all resources on a cluster. For more examples and usage information, see the [Remove-ClusterResource](/powershell/module/failoverclusters/remove-clusterresource) reference documentation.

> [!NOTE]
> You will need to temporarily enable Credential Security Service Provider (CredSSP) authentication to remove a cluster. For more information, see [Enable-WSManCredSSP](/powershell/module/microsoft.wsman.management/enable-wsmancredssp).

The following example removes cluster resources by name on cluster Cluster1:

```powershell
Remove-ClusterResource -Cluster Cluster1 -Name "Cluster Disk 4"
```

This example removes cluster Cluster1 entirely using the `Remove-Cluster` cmdlet:

```powershell
Remove-Cluster -Cluster Cluster1
```

## Next steps

- You should validate the cluster afterwards after making changes. See [Validate an Azure Stack HCI cluster](../deploy/validate.md) for more information.
- Learn how to manage your clusters using Windows Admin Center. See [Manage clusters on Azure Stack HCI using Windows Admin Center](cluster.md).
