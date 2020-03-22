--- 
title: Manage Azure Stack HCI clusters using Windows PowerShell 
description: Learn how to manage clusters on Azure Stack HCI using Windows PowerShell 
author: v-dasis 
ms.topic: article 
ms.date: 03/22/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Manage Azure Stack HCI clusters using Windows PowerShell

> Applies to Windows Server 2019

Windows PowerShell can be used to manage resources and configure features on your Azure Stack HCI clusters. For information using on managing the VMS in your cluster, see [Manage VMs on Azure Stack HCI with Windows PowerShell].

For the complete reference documentation for managing clusters using PowerShell, see [FailoverCluster reference](https://docs.microsoft.com/powershell/module/failoverclusters/?view=win10-ps).

## Run Windows PowerShell

The Windows PowerShell app is used to perform all the tasks in this article. It is recommended that you pin the app to your taskbar for convenience.

1. Click the Taskbar search bar in the lower left and then type *PowerShell* in the text field.
2. Under **Windows PowerShell** on the right, select **Run as administrator**.

## View cluster settings and resources

To see the current cluster and its member nodes, run:

```powershell
Get-Cluster
Get-ClusterNode
```

To see which Windows features are installed on the cluster use the Get-WindowsFeature cmdlet. For example:

```powershell
Get-WindowsFeature "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "BitLocker"
```

To see network adapters and their properties such as Name, IPv4 addresses, and VLAN ID:

```powershell
Get-NetAdapter | Where Status -Eq "Up" | Sort InterfaceAlias | Format-Table Name, InterfaceDescription, Status, LinkSpeed, VLANID, MacAddress
Get-NetAdapter | Where Status -Eq "Up" | Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Sort InterfaceAlias | Format-Table InterfaceAlias, IPAddress, PrefixLength
```

To see Hyper-V virtual switches and how physical network adapters are teamed:

```powershell
Get-VMSwitch
Get-VMSwitchTeam
```

To see host virtual network adapters

```powershell
Get-VMNetworkAdapter -ManagementOS | Format-Table Name, IsManagementOS, SwitchName
Get-VMNetworkAdapterTeamMapping -ManagementOS | Format-Table NetAdapterName, ParentAdapter
```

To see whether Storage Spaces Direct is enabled and the default storage pool that's created automatically:

```powershell
Get-ClusterStorageSpacesDirect
Get-StoragePool -IsPrimordial $False
```

## Start or stop a cluster

Use the `Start-Cluster` and `Stop-Cluster` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Start-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/start-cluster?view=win10-ps) and [Stop-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/stop-cluster?view=win10-ps) reference documentation.

Starts the Cluster service on all nodes of the cluster on which it is not yet started:

```powershell
Start-Cluster
Name 
---- 
mycluster
```

This example stops the Cluster service on all nodes in the cluster named cluster1, which will stop all services and applications configured in the cluster:

```powershell
Stop-Cluster -Name cluster1
```

## Add or remove a server

Use the `Add-ClusterNode` and `Remove-ClusterNode` cmdlets to add or remove a server node for your cluster. For more examples and usage information, see the [Add-ClusterNode](https://docs.microsoft.com/powershell/module/failoverclusters/add-clusternode?view=win10-ps) and [Remove-ClusterNode](https://docs.microsoft.com/powershell/module/failoverclusters/remove-clusternode?view=win10-ps) reference documentation.

This example adds node named node4 to the local cluster:

```powershell
Add-ClusterNode -Name node4
Name                                                                      State 
----                                                                      ----- 
node4                                                                        Up
```

This example removes the node named node4 from the local cluster:

```powershell
Remove-ClusterNode -Name node4
```

## Set quorum options

Use the `Set-ClusterQuorum` cmdlet to set quorum options for the cluster. For more examples and usage information, see the [Set-ClusterQuorum](https://docs.microsoft.com/powershell/module/failoverclusters/set-clusterquorum?view=win10-ps) reference documentation.

This example changes the quorum configuration to Node Majority on the local cluster

```powershell
Set-ClusterQuorum -NodeMajority
Cluster                    QuorumResource                  QuorumType 
-------                    --------------                  ---------- 
cluster1                                                 NodeMajority
```

This example changes the quorum configuration to Node and Disk Majority on the local cluster, using the disk resource named Cluster Disk 7 for the disk witness.

```powershell
Set-ClusterQuorum -DiskWitness "Cluster Disk 7"
Cluster                    QuorumResource                  QuorumType 
-------                    --------------                  ---------- 
cluster1                   Cluster Disk 7         NodeAndDiskMajority
```

## Enable Storage Spaces Direct

Use the `Enable-ClusterStorageSpacesDirect` cmdlet to enable Storage Spaces Direct (S2D) on the cluster. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](https://docs.microsoft.com/powershell/module/failoverclusters/enable-clusterstoragespacesdirect?view=win10-ps) reference documentation.

This example enables Storage Spaces Direct on the local cluster:

```powershell
Enable-ClusterStorageSpacesDirect                                               NodeMajority
```

## Configure a Hyper-V host

Use the `Set-VMHost` cmdlet to configure various Hyper-V host settings, such as VHD and VM paths, live migrations, storage migrations, authentication, NUMA spanning and others. For more examples and usage information, see the [Enable-ClusterStorageSpacesDirect](https://docs.microsoft.com/powershell/module/hyper-v/Set-VMHost?view=win10-ps) reference documentation.

This example specifies new default locations for virtual hard disks and VMs on the local Hyper-V host:

```powershell
Set-VMHost -VirtualHardDiskPath "C:\Hyper-V\Virtual Hard Disks" -VirtualMachinePath "C:\Hyper-V\Configuration Files"
```

This example configures the local Hyper-V host to allow 10 simultaneous live migrations and storage migrations:

```powershell
Set-VMHost -MaximumVirtualMachineMigrations 10 -MaximumStorageMigrations 10
```

This example configures the local Hyper-V host to use Kerberos to authenticate incoming live migrations:

```powershell
Set-VMHost -VirtualMachineMigrationAuthenticationType Kerberos
```

This example disables NUMA spanning on the local Hyper-V host:

```powershell
Set-VMHost -NumaSpanningEnabled $false
```

## Validate a cluster

Use the `Test-Cluster` cmdlet to run validation tests on the cluster. For more examples and usage information, see the [Test-Cluster](https://docs.microsoft.com/powershell/module/failoverclusters/test-cluster?view=win10-ps) reference documentation.

This example runs all applicable cluster validation tests on the local cluster:

```powershell
Test-Cluster
Mode                LastWriteTime     Length Name 
----                -------------     ------ ---- 
-a---        10/10/2008   6:31 PM    1132255 Test-Cluster on 2008.10.10 At 18.22.53.mht
```

This example lists the names of all tests and categories in cluster validation. Specify these test names with *Ignore* or *Include* parameters to run specific tests:


```powershell
Test-Cluster -List
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
Inventory                               List BIOS Information                   List BIOS information from each node. 
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

The following example removes cluster resources by name:

```powershell
Get-ClusterResource -Name "<NAME>" | Remove-ClusterResource
```

This example removes the cluster entirely:

```powershell
Get-ClusterResource -Name "<NAME>" | Remove-ClusterResource
```

## Next Steps

 - Use PowerShell to manage the VMs in your cluster. See [Manage VMs on Azure Stack HCI with Windows PowerShell].

- Learn how to manage your clusters using Windows Admin Center. See [Manage clusters on Azure Stack HCI using Windows Admin Center].