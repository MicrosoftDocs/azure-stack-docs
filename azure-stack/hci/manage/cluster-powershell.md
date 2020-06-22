---
title: Manage Azure Stack HCI clusters using PowerShell
description: Learn how to manage clusters on Azure Stack HCI using PowerShell
author: v-dasis
ms.topic: how-to
ms.date: 05/21/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Manage Azure Stack HCI clusters using PowerShell

> Applies to Windows Server 2019

Windows PowerShell can be used to manage resources and configure features on your Azure Stack HCI clusters.

Typically, you manage clusters from a remote computer running Windows 10, rather than on a host server in a cluster. This remote computer is called the management computer.

> [!NOTE]
> When running PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the cluster you are managing. In addition, you will need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

For the complete reference documentation for managing clusters using PowerShell, see the [FailoverCluster reference](https://docs.microsoft.com/powershell/module/failoverclusters/?view=win10-ps).

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

Use the `Start-Cluster` and `Stop-Cluster` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Start-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/start-cluster?view=win10-ps) and [Stop-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/stop-cluster?view=win10-ps) reference documentation.

Starts the Cluster service on all server nodes of the cluster on which it is not yet started:

```powershell
Start-Cluster -Name Cluster1
```

This example stops the Cluster service on all nodes in the cluster named Cluster1, which will stop all services and applications configured in the cluster:

```powershell
Stop-Cluster -Name Cluster1
```

## Add or remove a server

Use the `Add-ClusterNode` and `Remove-ClusterNode` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Add-ClusterNode](https://docs.microsoft.com/powershell/module/failoverclusters/add-clusternode?view=win10-ps) and [Remove-ClusterNode](https://docs.microsoft.com/powershell/module/failoverclusters/remove-clusternode?view=win10-ps) reference documentation.

This example adds a server named Node4 to a cluster named Cluster1. Make sure the server is powered on and connected to the cluster network first.

```powershell
Add-ClusterNode -Cluster Cluster1 -Name Node4
```

This example removes the node named node4 from cluster Cluster1:

```powershell
Remove-ClusterNode -Cluster Cluster1 -Name Node4
```

## Set quorum options

Use the `Set-ClusterQuorum` cmdlet to set quorum options for the cluster. For more examples and usage information, see the [Set-ClusterQuorum](https://docs.microsoft.com/powershell/module/failoverclusters/set-clusterquorum?view=win10-ps) reference documentation.

This example changes the quorum configuration to use a cloud witness on cluster Cluster1:

```powershell
Set-ClusterQuorum -Cluster Cluster1 -CloudWitness
```

This example changes the quorum configuration to Node and File Share Majority on the cluster Cluster1, using the disk resource at \\fileserver\fsw for the file share witness.

```powershell
Set-ClusterQuorum -Cluster Cluster1 -NodeAndFileShareMajority \\fileserver\fsw
```

## Enable Storage Spaces Direct

Use the `Enable-ClusterStorageSpacesDirect` cmdlet to enable Storage Spaces Direct on the cluster. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](https://docs.microsoft.com/powershell/module/failoverclusters/enable-clusterstoragespacesdirect?view=win10-ps) reference documentation.

This example enables Storage Spaces Direct on Server1:

```powershell
Enable-ClusterStorageSpacesDirect -CimSession Cluster1
```

## Configure a Hyper-V host

Use the `Set-VMHost` cmdlet to configure various Hyper-V host settings, such as VHD and VM paths, live migrations, storage migrations, authentication, NUMA spanning and others. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](https://docs.microsoft.com/powershell/module/hyper-v/Set-VMHost?view=win10-ps) reference documentation.

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

## Validate a cluster

Use the `Test-Cluster` cmdlet to run validation tests on a cluster. For more examples and usage information, see the [Test-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/test-cluster?view=win10-ps) reference documentation.

This example runs all applicable cluster validation tests on a cluster named Cluster1:

```powershell
Test-Cluster -Cluster Cluster1
```

This example lists the names of all tests and categories in cluster validation. Specify these test names with *Ignore* or *Include* parameters to run specific tests:


```powershell
Test-Cluster -Cluster Cluster1 -List
Category                                DisplayName                             Description
--------                                -----------                             -----------
Cluster Configuration                   List Cluster Core Groups                List information about the available...
Cluster Configuration                   List Cluster Network Information        List cluster-specific network settin...
Cluster Configuration                   List Cluster Resources                  List the resources that are configur...
Cluster Configuration                   List Cluster Volumes                    List information for the volumes in ...
Cluster Configuration                   List Clustered Roles                    List information about clustered roles.
Cluster Configuration                   Validate Quorum Configuration           Validate that the current quorum con...
Cluster Configuration                   Validate Resource Status                Validate that cluster resources are ...
Cluster Configuration                   Validate Service Principal Name         Validate that a Service Principal Na...
Cluster Configuration                   Validate Volume Consistency             If any volumes are flagged as incons...
Hyper-V Configuration                   List Information About Servers Runni... List Hyper-V related information on ...
Hyper-V Configuration                   Validate Compatibility of Virtual Fi... Validate that all specified nodes sh...
Hyper-V Configuration                   Validate Hyper-V Memory Resource Poo... Validate that all specified nodes sh...
Hyper-V Configuration                   Validate Hyper-V Network Resource Po... Validate that all specified nodes sh...
Hyper-V Configuration                   Validate Hyper-V Processor Resource ... Validate that all specified nodes sh...
Hyper-V Configuration                   Validate Hyper-V Role Installed         Validate that all the nodes have the...
Hyper-V Configuration                   Validate Hyper-V Storage Resource Po... Validate that all specified nodes sh...
Hyper-V Configuration                   Validate Matching Processor Manufact... Validate that all specified nodes sh...
Hyper-V Configuration                   List Hyper-V Virtual Machine Informa... List Hyper-V virtual machine informa...
Hyper-V Configuration                   Validate Hyper-V Integration Service... Validate that the Hyper-V integratio...
Hyper-V Configuration                   Validate Hyper-V Virtual Machine Net... Validate that all virtual machines o...
Hyper-V Configuration                   Validate Hyper-V Virtual Machine Sto... Validate that all virtual machines o...
Inventory                               List Fibre Channel Host Bus Adapters    List Fibre Channel host bus adapters...
Inventory                               List iSCSI Host Bus Adapters            List iSCSI host bus adapters on each...
Inventory                               List SAS Host Bus Adapters              List Serial Attached SCSI (SAS) host...
Inventory                               List BIOS Information                   List BIOS information from each node...
Inventory                               List Environment Variables              List environment variables set on ea...
Inventory                               List Memory Information                 List memory information for each node.
Inventory                               List Operating System Information       List information about the operating...
Inventory                               List Plug and Play Devices              List Plug and Play devices on each n...
Inventory                               List Running Processes                  List the running processes on each n...
Inventory                               List Services Information               List information about the services ...
Inventory                               List Software Updates                   List software updates that have been...
Inventory                               List System Drivers                     List the system drivers on each node.
Inventory                               List System Information                 List system information such as comp...
Inventory                               List Unsigned Drivers                   List the unsigned drivers on each node.
Network                                 List Network Binding Order              List the order in which networks are...
Network                                 Validate Cluster Network Configuration  Validate the cluster networks that w...
Network                                 Validate IP Configuration               Validate that IP addresses are uniqu...
Network                                 Validate Multiple Subnet Properties     For clusters using multiple subnets,...
Network                                 Validate Network Communication          Validate that servers can communicat...
Network                                 Validate Windows Firewall Configuration Validate that the Windows Firewall i...
Storage                                 List Disks                              List all disks visible to one or mor...
Storage                                 List Potential Cluster Disks            List disks that will be validated fo...
Storage                                 Validate CSV Network Bindings           Validate that network bindings requi...
Storage                                 Validate CSV Settings                   Validate that settings and configura...
Storage                                 Validate Disk Access Latency            Validate acceptable latency for disk...
Storage                                 Validate Disk Arbitration               Validate that a node that owns a dis...
Storage                                 Validate Disk Failover                  Validate that a disk can fail over s...
Storage                                 Validate File System                    Validate that the file system on dis...
Storage                                 Validate Microsoft MPIO-based disks     Validate that disks that use Microso...
Storage                                 Validate Multiple Arbitration           Validate that in a multiple-node arb...
Storage                                 Validate SCSI device Vital Product D... Validate uniqueness of inquiry data ...
Storage                                 Validate SCSI-3 Persistent Reservation  Validate that storage supports the S...
Storage                                 Validate Simultaneous Failover          Validate that disks can fail over si...
System Configuration                    Validate Active Directory Configuration Validate that all the nodes have the...
System Configuration                    Validate All Drivers Signed             Validate that tested servers contain...
System Configuration                    Validate Cluster Service and Driver ... Validate startup settings used by se...
System Configuration                    Validate Memory Dump Settings           Validate that none of the nodes curr...
System Configuration                    Validate Operating System Edition       Validate that all tested servers are...
System Configuration                    Validate Operating System Installati... Validate that the operating systems ...
System Configuration                    Validate Operating System Version       Validate that the operating systems ...
System Configuration                    Validate Required Services              Validate that services required for ...
System Configuration                    Validate Same Processor Architecture    Validate that all servers run as 64-...
System Configuration                    Validate Service Pack Levels            Validate that all servers with same ...
System Configuration                    Validate Software Update Levels         Validate that all tested servers hav...
System Configuration                    Validate System Drive Variable          Validate that all nodes have the sam...
```

## Remove cluster and resources

Use the `Remove-ClusterResource` cmdlet to remove one or all resources on a cluster. For more examples and usage information, see the [Remove-ClusterResource](https://docs.microsoft.com/powershell/module/failoverclusters/remove-clusterresource?view=win10-ps) reference documentation.

> [!NOTE]
> You will need to temporarily enable Credential Security Service Provider (CredSSP) authentication to remove a cluster. For more information, see [Enable-WSManCredSSP](https://docs.microsoft.com/powershell/module/microsoft.wsman.management/enable-wsmancredssp?view=powershell-7).

The following example removes cluster resources by name on cluster Cluster1:

```powershell
Remove-ClusterResource -Cluster Cluster1 -Name "Cluster Disk 4"
```

This example removes cluster Cluster1 entirely using the `Remove-Cluster` cmdlet:

```powershell
Remove-Cluster -Cluster Cluster1
```

## Next steps

Learn how to manage your clusters using Windows Admin Center. See [Manage clusters on Azure Stack HCI using Windows Admin Center](cluster.md).