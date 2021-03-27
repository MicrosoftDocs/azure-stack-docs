---
title: Deploy an Azure Stack HCI cluster set
description: Learn how to Deploy an Azure Stack HCI cluster set
author: v-dasis
ms.topic: how-to
ms.date: 03/27/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Deploy an Azure Stack HCI cluster set

> Applies to Azure Stack HCI, version v20H2; Windows Server 2019

A cluster set is a loosely-coupled grouping of multiple failover clusters for compute, storage, or hyper-converged environments. By using a cluster set, you can increase the number of server nodes in a single Software Defined Data Center (SDDC) cloud by orders of magnitude. Cluster sets enable virtual machine (VM) flexibility across member clusters and a presents a unified storage namespace.

While preserving existing failover cluster management experiences on member clusters, a cluster set also offers key use cases around lifecycle management. This article provides you the necessary information and instructions for deployment. Windows PowerShell is used to create cluster sets.

You can mix Storage Spaces Direct clusters with traditional clusters in a set. Or, you can scale Hyper-V compute or Storage Spaces Direct clusters.

Cluster sets been tested and supported up to 64 total cluster nodes. However, cluster sets architecture scales to much larger limits and is not something that is hardcoded for a limit. Let us know if larger scale is critical to you and how you plan to use it.

## Benefits

Cluster sets allows for clustering multiple clusters together to create a large fabric, while each cluster remains independent for resiliency. For example, you have a several 4-node HCI clusters running virtual machines. Each cluster provides the resiliency needed for itself.

Cluster sets offer the following value propositions:

- Significantly increase the supported SDDC cloud scale for running highly available VMs by combining multiple smaller clusters into a single large fabric, even while keeping the software fault boundary to a single cluster

- Manage entire failover cluster lifecycle including onboarding and retiring clusters, without impacting tenant virtual machine availability, via fluidly migrating virtual machines across this large fabric

- Easily change the compute-to-storage ratio in your hyper-converged environment

- Benefit from [Azure-like Fault Domains and Availability sets](htttps://docs.microsoft.com/azure/virtual-machines/windows/manage-availability) across clusters in initial virtual machine placement and subsequent virtual machine migration

- Mix-and-match different generations of CPU hardware into the same cluster set fabric, even while keeping individual fault domains homogeneous for maximum efficiency. Please note that the recommendation of same hardware is still present within each individual cluster as well as the entire cluster set.

If the storage or memory starts to fill up, scaling up is your next step. With scaling up, there are some options and considerations:

- Add more storage to the current cluster. With Storage Spaces Direct, this may be tricky as the exact same model/firmware drives may not be available. The consideration of rebuild times also need to be taken into account.

- Add more memory. What if you are maxed out on the memory the machines can handle?  What if all available memory slots are full?

- Add additional compute nodes with drives into the current cluster. This takes us back to Option 1 needing to be considered.

- Purchase a whole new cluster.

This is where cluster sets provides the benefit of scaling. By adding clusters into a cluster set, you can take advantage of storage or memory that may be available on another cluster without any additional purchases. From a resiliency perspective, adding additional nodes to a Storage Spaces Direct is not going to provide additional votes for quorum.

A Storage Spaces Direct Cluster can survive the loss of 2 nodes before going down. If you have a 4-node HCI cluster, 3 nodes go down will take the entire cluster down. If you have an 8-node cluster, 3 nodes go down will take the entire cluster down. With Cluster sets that has two 4-node HCI clusters in the set, 2 nodes in one HCI go down and 1 node in the other HCI go down, both clusters remain up. 

Is it better to create one large 16-node Storage Spaces Direct cluster or break it down into four 4-node clusters and use cluster sets?  Having four 4-node clusters with cluster sets gives the same scale, but better resiliency in that multiple compute nodes can go down (unexpectedly or for maintenance) and production remains.

## Architecture

The following diagram illustrates a cluster set at a high level:

 :::image type="content" source="media/cluster-set/cluster-set.png" alt-text="Cluster set" lightbox="media/cluster-set/cluster-set.png":::

The following provides a summary of each of the elements shown:

### Management cluster

The management cluster hosts the highly-available management plane of the cluster set and the cluster set namespace referral Scale-Out File Server (SOFS). A management cluster is logically decoupled from member clusters that run the VM workloads. This makes the cluster set management plane resilient to any localized cluster-wide failures, such as loss of power of a member cluster.

### Cluster set namespace referral SOFS

A namespace for cluster sets is provided via a continuously available referral scale-out file server (SOFS) server role running on the management cluster. This i similar to the Distributed File System Namespace (DFSN). Unlike DFSN however, cluster set namespace referral metadata is auto-populated on all nodes without any intervention, so there is almost no performance overhead in the storage access path.

Specifically, the cluster set namespace referral SOFS is a Scale-Out File Server where each Server Message Block (SMB) share on the cluster set namespace SOFS is a referral share of type `SimpleReferral`. This referral allows SMB clients access to the target SMB share hosted on the member cluster SOFS. The cluster set namespace referral SOFS is a lightweight referral mechanism and as such, does not participate in the I/O path. The SMB referrals are cached perpetually on each of the client nodes and the cluster set namespace dynamically updates the referrals as needed automatically. Referral information is persistently cached in each cluster set node, even during reboots.

### Cluster set master

In a cluster set, the communication between the member clusters is loosely coupled and coordinated by the Cluster Set Master (CS-Master) resource. Like other cluster set resources, CS-Master is highly available and resilient to individual member cluster failures or management cluster node failures. Through a cluster set WMI provider, CS-Master provides the management endpoint for all cluster set management actions.

### Member cluster

A member cluster in a cluster set is a cluster running VM and Storage Spaces Direct workloads. Multiple member clusters participate in a cluster set deployment, forming the larger SDDC cloud fabric. Member clusters differ from the management cluster in two key aspects: member clusters participate in fault domain and availability set constructs, and member clusters are sized to host VM and Storage Spaces Direct workloads. Cluster set VMs that move across member clusters in a cluster set aren't hosted on the management cluster for this reason.

### Cluster set worker

The CS-Master interacts with a cluster resource on the member clusters called Cluster Set Worker (CS-Worker). CS-Worker responds to requests by the CS-Master, including VM placement and resource inventorying. There is one CS-Worker instance per member cluster.

### Fault domain

A fault domain is a group of hardware and software that could fail together. While you could designate one or more clusters together as a fault domain, each node could participate in a fault domain in an availability set. Fault domain boundaries are based on data center topology, networking architecture and other considerations.

Using stretched clusters, you can failover VMs across fault domains in a disaster recovery situation if an entire site goes down.

### Availability set

An availability set is used to configure the desired redundancy of clustered workloads across fault domains by grouping and deploying workloads into the availability set. For a two-tier application, you should configure at least two VMs in an availability set for each tier, which ensures that when a fault domain in an availability set goes down, your application will at least have one VM in each tier hosted on a different fault domain.

## Deployment considerations

When considering if cluster sets is something you can use, ask yourself the following:

- Do you need to go beyond the current Azure Stack HCI compute and storage scale limits?
- Are compute and storage not identical?
- Do you live migrate VMs between clusters?
- Would you like Azure-like computer availability sets and fault domains across multiple clusters?
- Do you need to take the time to look at all your clusters to determine where any new VMs need to be placed?
- Does moving SQL Server VMs between clusters require licensing SQL to run on additional nodes?

If your answer is yes, then cluster sets is what you need.

## Requirements and limitations

Here are a few requirements and limitations of cluster sets:

- Member set servers must be running Windows Server 2019 or Azure Stack HCI. If you want to add a Windows Server 2016 cluster for example, you must first migrate the cluster servers to Windows Server 2019.

- Use the same processor hardware for all member cluster servers as well as the entire cluster set for live migrations between member clusters to occur.

- Use Storage Replica (SR) across member clusters to realize storage resiliency to cluster failures. When using SR, bear in mind that namespace storage UNC paths will not change automatically on SR failover to the replica target cluster.

- Cluster set VMs must be manually live-migrated across clusters - they cannot automatically failover.

- All member clusters in a cluster set must be in the same AD forest.

- Storage Spaces Direct operates within a single member cluster and not across member clusters in a cluster set, with each cluster having its own storage pool.

## Create a cluster set

Complete the following workflow to create a cluster set. Here is an example cluster set to follow. The name of the cluster set in this example is **CSMASTER**.

   | Cluster name | Infrastructure SOFS Name |
   |--------------|-------------------------------------------|
   | SET-CLUSTER  | SOFS-CLUSTERSET                           |
   | CLUSTER1     | SOFS-CLUSTER1                             |
   | CLUSTER2     | SOFS-CLUSTER2                             |

1. Configure a management client running Windows Server 2019 or Azure Stack HCI.
1. Install Failover Cluster tools on the management cluster server.
1. Create cluster members, with at least two clusters and with at least two Cluster Shared Volumes (CSVs) in each cluster.
1. Create a management cluster (physical or guest) that straddles the member clusters. This ensures that the cluster set management plane continues to be available despite possible member cluster failures.
1. Use the following command to create the cluster set:

    ```PowerShell
    New-ClusterSet -Name CSMASTER -NamespaceRoot SOFS-CLUSTERSET -CimSession SET-CLUSTER
    ```

1. Use the following command to add nodes to the cluster set:

    ```PowerShell
    Add-ClusterSetMember -ClusterName CLUSTER1 -CimSession CSMASTER -InfraSOFSName SOFS-CLUSTER1
    Add-ClusterSetMember -ClusterName CLUSTER2 -CimSession CSMASTER -InfraSOFSName SOFS-CLUSTER2
    ```

   > [!NOTE]
   > If you are using a static IP address, you must include *-StaticAddress x.x.x.x* on the **New-ClusterSet** command.

1. To enumerate all member clusters in the cluster set:

    ```PowerShell
    Get-ClusterSetMember -CimSession CSMASTER
    ```

1. To enumerate all the member clusters in the cluster set including the management cluster nodes:

    ```PowerShell
    Get-ClusterSet -CimSession CSMASTER | Get-Cluster | Get-ClusterNode
    ```

1. To list all nodes from all member clusters:

    ```PowerShell
    Get-ClusterSetNode -CimSession CSMASTER
    ```

1. To list all resource groups across the cluster set:

    ```PowerShell
    Get-ClusterSet -CimSession CSMASTER | Get-Cluster | Get-ClusterGroup
    ```

1. To verify the cluster set contains one SMB share (`ScopeName` being the Infrastructure File Server name) on the infrastructure SOFS for each cluster member CSV volume:

    ```PowerShell
    Get-SmbShare -CimSession CSMASTER
    ```

1. Review the cluster set debug logs for the cluster set, the management cluster, and each cluster member:

    ```PowerShell
    Get-ClusterSetLog -ClusterSetCimSession CSMASTER -IncludeClusterLog -IncludeManagementClusterLog -DestinationFolderPath <path>
    ```

1. Configure [Kerberos with constrained delegation](https://techcommunity.microsoft.com/t5/virtualization/live-migration-via-constrained-delegation-with-kerberos-in/ba-p/382334) between all cluster set members.

1. Configure the cross-cluster VM live migration authentication type to Kerberos on each node in the Cluster Set.

    ```PowerShell
    foreach($h in $hosts){ Set-VMHost -VirtualMachineMigrationAuthenticationType Kerberos -ComputerName $h }
    ```

1. Add the management cluster to the local administrators group on each cluster member node in the cluster set:

    ```PowerShell
    foreach($h in $hosts){ Invoke-Command -ComputerName $h -ScriptBlock {Net localgroup administrators /add <management_cluster_name>$} }
    ```

## Create cluster set VMs

After creating the cluster set, the next step is to create VMs. You should perform the following checks beforehand:

- Check available memory on each cluster node
- Check available disk space on each cluster node
- Check any specific VM storage requirements in terms of speed and performance

The `Get-ClusterSetOptimalNodeForVM` command identifies the optimal cluster and then deploy the VM on it. In the below example, a new VM is created as follows with:

- 4 GB available
- 1 virtual processor
- 10% minimum CPU available

```PowerShell
# Identify the optimal node to create a new virtual machine
$memoryinMB=4096
$vpcount = 1
$targetnode = Get-ClusterSetOptimalNodeForVM -CimSession CSMASTER -VMMemory $memoryinMB -VMVirtualCoreCount $vpcount -VMCpuReservation 10
$secure_string_pwd = convertto-securestring "<password>" -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential ("<domain\account>",$secure_string_pwd)

# Deploy the virtual machine on the optimal node
Invoke-Command -ComputerName $targetnode.name -scriptblock { param([String]$storagepath); New-VM CSVM1 -MemoryStartupBytes 3072MB -path $storagepath -NewVHDPath CSVM.vhdx -NewVHDSizeBytes 4194304 } -ArgumentList @("\\SOFS-CLUSTER1\VOLUME1") -Credential $cred | Out-Null

Start-VM CSVM1 -ComputerName $targetnode.name | Out-Null
Get-VM CSVM1 -ComputerName $targetnode.name | fl State, ComputerName
```

When complete, you are shown which cluster node the VM was deployed on. For the above example, it would show as:

```
State         : Running
ComputerName  : 1-S2D2
```

If there is not enough memory, CPU capacity, or disk space available to add the VM, you will receive the following error:

```
Get-ClusterSetOptimalNodeForVM : A cluster node is not available for this operation.
```

Once the VM is created, it is displayed in Hyper-V manager on the specific node specified. To add it as a cluster set VM and add it to the cluster, use this command:

```PowerShell
Register-ClusterSetVM -CimSession CSMASTER -MemberName $targetnode.Member -VMName CSVM1
```

When complete, the output is:

```
Id  VMName  State  MemberName  PSComputerName
--  ------  -----  ----------  --------------
 1  CSVM1     On   CLUSTER1    CSMASTER
```

If you have created a cluster using existing VMs, the VMs need to be registered with the cluster set. To register all VMs at once, use:

```PowerShell
Get-ClusterSetMember -Name CLUSTER3 -CimSession CSMASTER | Register-ClusterSetVM -RegisterAll -CimSession CSMASTER
```

Next, add the VM path to the cluster set namespace.

As an example, suppose an existing cluster is added to the cluster set with pre-configured VMs that reside on the local Cluster Shared Volume (CSV). The path for the VHDX would be something similar to `C:\ClusterStorage\Volume1\MYVM\Virtual Hard Disks\MYVM.vhdx1`.

A storage migration is needed, as CSV paths are by design local to a single member cluster and are therefore not be accessible to the VM once they are live migrated across member clusters.

In this example, CLUSTER3 is added to the cluster set using `Add-ClusterSetMember` with the scale-out file server SOFS-CLUSTER3. To move the VM configuration and storage, the command is:

```PowerShell
Move-VMStorage -DestinationStoragePath \\SOFS-CLUSTER3\Volume1 -Name MyVM
```

Once complete, you will receive a warning:

```
WARNING: There were issues updating the virtual machine configuration that may prevent the virtual machine from running. For more information view the report file below.
WARNING: Report file location: C:\Windows\Cluster\Reports\Update-ClusterVirtualMachineConfiguration '' on date at time.htm.
```

This warning can be ignored as the warning is "No changes in the virtual machine role storage configuration were detected". The reason for the warning is that the actual physical location does not change; only the configuration paths do.

For more information on `Move-VMStorage`, see [Move-VMStorage](https://docs.microsoft.com/powershell/module/hyper-v/move-vmstorage).

Live migrating a VM between different clusters in the set is not the same as in the past. In non-cluster set scenarios, the steps would be:

1. Remove the VM role from the cluster.
1. Live migrate the VM to a member node of a different cluster.
1. Add the VM into the cluster as a new VM role.

With cluster sets, these steps are not necessary and only one command is needed. First, you should set all networks to be available for the migration with the command:

```PowerShell
Set-VMHost -UseAnyNetworkForMigration $true
```

For example, to move a cluster set VM from CLUSTER1 to NODE2-CL3 on CLUSTER3, the command would be:

```PowerShell
Move-ClusterSetVM -CimSession CSMASTER -VMName CSVM1 -Node NODE2-CL3
```

This command does not move the VM storage or configuration files and is not necessary as the path to the VM remains as \\\\SOFS-CLUSTER1\VOLUME1. Once a VM has been registered with the infrastructure file server share path, the drives and VM do not require being on the same node as the VM.

## Create the infrastructure scale-out file server

There is one Infrastructure SOFS cluster role on a cluster. The Infrastructure SOFS role is created by specifying the `-Infrastructure` switch parameter to the `Add-ClusterScaleOutFileServerRole` cmdlet. For example:

 ```PowerShell
 Add-ClusterScaleoutFileServerRole -Name "my_infra_sofs_name" -Infrastructure
```

Each CSV volume created automatically triggers the creation of an SMB share with an auto-generated name based on the CSV volume name. You cannot directly create or modify SMB shares under an SOFS role, other than via CSV volume create/modify operations.

In hyper-converged configurations, an Infrastructure SOFS allows an SMB client (Hyper-V host) to communicate with guaranteed continuous availability (CA) to the Infrastructure SOFS SMB server. This hyper-converged SMB loopback CA is achieved via VMs accessing their virtual disk (VHDX) files where the owning VM identity is forwarded between the client and server. This identity forwarding allows the use of ACLs for VHDx files just as in standard hyper-converged cluster configurations as before.

Once a cluster set is created, the cluster set namespace relies on an Infrastructure SOFS on each of the member clusters, and additionally an Infrastructure SOFS in the management cluster.

At the time a member cluster is added to a cluster set, you can specify the name of an Infrastructure SOFS on that cluster if one already exists. If the Infrastructure SOFS does not exist, a new Infrastructure SOFS role on the new member cluster is created by this operation. If an Infrastructure SOFS role already exists on the member cluster, the Add operation implicitly renames it to the specified name as needed. Any existing SMB servers, or non-Infrastructure SOFS roles on the member clusters, are not used by the cluster set.

When the cluster set is created, you have the option to use an existing AD computer object as the namespace root on the management cluster. Cluster set creation creates the Infrastructure SOFS cluster role on the management cluster or renames the existing Infrastructure SOFS role. The Infrastructure SOFS on the management cluster is used as the cluster set namespace referral SOFS.

## Create fault domains and availability sets

Azure-like fault domains and availability sets can be configured in a cluster set. This is beneficial for initial VM placements and migrations between clusters.

The example below has four clusters in the cluster set. Within the set, one fault domain is created with two of the clusters and a second fault domain is created with the other two clusters. These two fault domains comprise the availability set.

In the example below, CLUSTER1 and CLUSTER2 are in the fault domain **FD1** and CLUSTER3 and CLUSTER4 are in the fault domain **FD2**. The availability set is **CSMASTER-AS**.

To create the fault domains, the commands are:

```PowerShell
New-ClusterSetFaultDomain -Name FD1 -FdType Logical -CimSession CSMASTER -MemberCluster CLUSTER1,CLUSTER2 -Description "First fault domain"

New-ClusterSetFaultDomain -Name FD2 -FdType Logical -CimSession CSMASTER -MemberCluster CLUSTER3,CLUSTER4 -Description "Second fault domain"
```

To ensure they have been created successfully, `Get-ClusterSetFaultDomain` can be run with its output shown for FD1:

```PowerShell
PS C:\> Get-ClusterSetFaultDomain -CimSession CSMASTER -FdName FD1 | fl *

PSShowComputerName    : True
FaultDomainType       : Logical
ClusterName           : {CLUSTER1, CLUSTER2}
Description           : First fault domain
FDName                : FD1
Id                    : 1
PSComputerName        : CSMASTER
```

Now that the fault domains have been created, the availability set is created:

```PowerShell
New-ClusterSetAvailabilitySet -Name CSMASTER-AS -FdType Logical -CimSession CSMASTER -ParticipantName FD1,FD2
```

To validate it has been created, use:

```PowerShell
Get-ClusterSetAvailabilitySet -AvailabilitySetName CSMASTER-AS -CimSession CSMASTER
```

When creating new VMs, use the `-AvailabilitySet` parameter to determine the optimal node for placement. Here is an example:

```PowerShell
# Identify the optimal node to create a new VM
$memoryinMB=4096
$vpcount = 1
$av = Get-ClusterSetAvailabilitySet -Name CSMASTER-AS -CimSession CSMASTER
$targetnode = Get-ClusterSetOptimalNodeForVM -CimSession CSMASTER -VMMemory $memoryinMB -VMVirtualCoreCount $vpcount -VMCpuReservation 10 -AvailabilitySet $av
$secure_string_pwd = convertto-securestring "<password>" -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential ("<domain\account>",$secure_string_pwd)
```

## Remove a cluster from a set

There are times when a cluster needs to be removed from a cluster set. As a best practice, all cluster set VMs should be moved out of the cluster beforehand. This can be done using the `Move-ClusterSetVM` and `Move-VMStorage` commands.

If the VMs are not moved out of the cluster first, all remaining cluster set VMs hosted on the cluster being removed will simply become highly available VMs bound to that cluster, assuming they have access to their storage. Cluster sets also automatically update their inventory by:

- No longer tracking the health of a removed cluster and the VMs running on it
- Removing the namespace and all references to shares hosted on the removed cluster

For example, the command to remove the CLUSTER1 cluster from a cluster set is:

```PowerShell
Remove-ClusterSetMember -ClusterName CLUSTER1 -CimSession CSMASTER
```

## System state backup

System state backup will backup the cluster state and metadata. Using Windows Server Backup, you can do restore just a node's cluster database if needed or do an authoritative restore to roll back the entire cluster database across all nodes. For cluster sets, we recommend doing an authoritative restore first for the member clusters and then for the management cluster. For more information on system state backup, see [Back up system state and bare metal](https://docs.microsoft.com/system-center/dpm/back-up-system-state-and-bare-metal).

## Next steps

- Learn more about [Storage Replica](https://docs.microsoft.com/windows-server/storage/storage-replica/storage-replica-overview).
- Learn more about [Stretched clusters](../concepts/stretched-clusters.md).