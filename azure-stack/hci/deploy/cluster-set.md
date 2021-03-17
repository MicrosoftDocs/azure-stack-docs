---
title: Deploy an Azure Stack HCI cluster set
description: Learn how to Deploy an Azure Stack HCI cluster set
author: v-dasis
ms.topic: how-to
ms.date: 03/17/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Deploy an Azure Stack HCI cluster set

> Applies to Azure Stack HCI, version v20H2; Windows Server 2019

A cluster set is a loosely-coupled grouping of multiple failover clusters for compute, storage, or hyper-converged. By using a cluster set, you can increase the number of server nodes in a single Software Defined Data Center (SDDC) cloud by orders of magnitude. Cluster sets enable virtual machine (VM) fluidity across member clusters and a presents a unified storage namespace across the set.

While preserving existing failover cluster management experiences on member clusters, a cluster set also offers key use cases around lifecycle management. This article provides you the necessary information and PowerShell instructions for deployment.

You can mix Storage Spaces Direct clusters with traditional clusters in a set. You can scale Hyper-V compute or Storage Spaces Direct clusters for scaling.

Cluster sets are managed currently using PowerShell commands or WMI.

Cluster sets can contain clustered servers running Windows Server 2019 or Azure Stack HCI. If you want to add a Windows Server 2016 cluster for example, you must first migrate the cluster to Windows Server 2019.

The recommendation for cluster sets is to use the same processor hardware within each individual cluster as well as the entire cluster cet for live migrations between clusters to occur.

Cluster set VMs can only be manually live-migrated across clusters - they cannot automatically failover.

Use Storage Replica (SR) across member clusters to realize storage resiliency to cluster failures. When using SR, bear in mind that namespace storage UNC paths will not change on SR failover to the replica target cluster.

Using stretched clusters, you can failover VMs across fault domains (sites) in a disaster recovery situation if an entire site goes down.

Both IPv4 and IPv6 are supported with cluster sets.

All member clusters in a cluster set must be in the same AD forest.

Cluster sets been tested and supported up to 64 total cluster nodes. However, cluster sets architecture scales to much larger limits and is not something that is hardcoded for a limit. Please let Microsoft know if larger scale is critical to you and how you plan to use it.

Storage Spaces Direct operates within a single cluster and not across member clusters in a cluster set, with each cluster having its own storage pool.

## Introduction

Cluster sets offer the following value propositions:

- Significantly increase the supported SDDC cloud scale for running highly available VMs by combining multiple smaller clusters into a single large fabric, even while keeping the software fault boundary to a single cluster
- Manage entire failover cluster lifecycle including onboarding and retiring clusters, without impacting tenant virtual machine availability, via fluidly migrating virtual machines across this large fabric
- Easily change the compute-to-storage ratio in your hyper-converged I
- Benefit from [Azure-like Fault Domains and Availability sets](htttps://docs.microsoft.com/azure/virtual-machines/windows/manage-availability) across clusters in initial virtual machine placement and subsequent virtual machine migration
- Mix-and-match different generations of CPU hardware into the same cluster set fabric, even while keeping individual fault domains homogeneous for maximum efficiency. Please note that the recommendation of same hardware is still present within each individual cluster as well as the entire cluster set.

The following diagram illustrates a cluster set at a high level:

 :::image type="content" source="media/cluster-set/cluster-set.png" alt-text="Cluster set" lightbox="media/cluster-set/cluster-set.png":::

The following provides a quick summary of each of the elements shown:

**Management cluster**

The management cluster hosts the highly-available management plane of the cluster set and the unified storage namespace (Cluster Set Namespace) referral Scale-Out File Server (SOFS). A management cluster is logically decoupled from member clusters that run the VM workloads. This makes the cluster set management plane resilient to any localized cluster-wide failures, such as loss of power of a member cluster.

**Member cluster**

A member cluster in a cluster set is a cluster running VM and Storage Spaces Direct workloads. Multiple member clusters participate in a single cluster set deployment, forming the larger SDDC cloud fabric. Member clusters differ from a management cluster in two key aspects: member clusters participate in fault domain and availability set constructs, and member clusters are also sized to host VM and Storage Spaces Direct workloads. Cluster set VMs that move across cluster boundaries in a cluster set can't be hosted on the management cluster for this reason.

**Cluster set namespace referral SOFS**

A cluster set namespace referral SOFS is a Scale-Out File Server where each Server Message Block (SMB) share on the Cluster Set Namespace SOFS is a referral share of type `SimpleReferral`. This referral allows SMB clients access to the target SMB share hosted on the member cluster SOFS. The cluster set namespace referral SOFS is a lightweight referral mechanism and as such, does not participate in the I/O path. The SMB referrals are cached perpetually on the each of the client nodes and the cluster sets namespace dynamically updates automatically these referrals as needed.

**Cluster set master**

In a cluster set, the communication between the member clusters is loosely coupled, and is coordinated by the Cluster Set Master (CS-Master) resource. Like other cluster resources, CS-Master is highly available and resilient to individual member cluster failures or management cluster node failures. Through a Cluster Set WMI provider, CS-Master provides the management endpoint for all cluster set management actions.

**Cluster set worker**

The CS-Master interacts with a new cluster resource on the member Clusters called *Cluster Set Worker* (CS-Worker). CS-Worker responds to requests by the CS-Master. This includes VM placement and resource inventorying. There is one CS-Worker instance per member cluster.

**Fault domain**

A fault domain is the grouping of software and hardware artifacts that the administrator determines could fail together when a failure does occur. While you could designate one or more clusters together as a fault domain, each node could participate in a fault domain in an availability set. Cluster sets by design leaves the decision of fault domain boundary determination to the administrator who is well-versed with data center topology considerations – e.g. PDU, networking – that member clusters share.

**Availability set**

An availability set is used to configure desired redundancy of clustered workloads across fault domains, by organizing those into an availability set and deploying workloads into that availability set. Let's say if you are deploying a two-tier application, we recommend that you configure at least two virtual machines in an availability set for each tier which will ensure that when one fault domain in that availability set goes down, your application will at least have one virtual machine in each tier hosted on a different fault domain of that same availability set.

## Why use cluster sets

Cluster sets provides the benefit of scale without sacrificing resiliency.

Cluster sets allows for clustering multiple clusters together to create a large fabric, while each cluster remains independent for resiliency. For example, you have a several 4-node HCI clusters running virtual machines. Each cluster provides the resiliency needed for itself. If the storage or memory starts to fill up, scaling up is your next step. With scaling up, there are some options and considerations.

1. Add more storage to the current cluster. With Storage Spaces Direct, this may be tricky as the exact same model/firmware drives may not be available. The consideration of rebuild times also need to be taken into account.
2. Add more memory. What if you are maxed out on the memory the machines can handle?  What if all available memory slots are full?
3. Add additional compute nodes with drives into the current cluster. This takes us back to Option 1 needing to be considered.
4. Purchase a whole new cluster

This is where cluster sets provides the benefit of scaling. If I add my clusters into a cluster set, I can take advantage of storage or memory that may be available on another cluster without any additional purchases. From a resiliency perspective, adding additional nodes to a Storage Spaces Direct is not going to provide additional votes for quorum. As mentioned in [Drive symmetry considerations](https://docs.microsoft.com/windows-server/storage/storage-spaces/drive-symmetry-considerations), a Storage Spaces Direct Cluster can survive the loss of 2 nodes before going down. If you have a 4-node HCI cluster, 3 nodes go down will take the entire cluster down. If you have an 8-node cluster, 3 nodes go down will take the entire cluster down. With Cluster sets that has two 4-node HCI clusters in the set, 2 nodes in one HCI go down and 1 node in the other HCI go down, both clusters remain up. Is it better to create one large 16-node Storage Spaces Direct cluster or break it down into four 4-node clusters and use cluster sets?  Having four 4-node clusters with cluster sets gives the same scale, but better resiliency in that multiple compute nodes can go down (unexpectedly or for maintenance) and production remains.

## Considerations for deployment

When considering if cluster sets is something you need to use, consider the following:

- Do you need to go beyond the current Azure Stack HCI compute and storage scale limits?
- Are all compute and storage not identically the same?
- Do you Live Migrate VMs between clusters?
- Would you like Azure-like computer availability sets and fault domains across multiple clusters?
- Do you need to take the time to look at all your clusters to determine where any new virtual machines need to be placed?

If your answer is yes, then cluster sets is what you need.

There are a few other items to consider where a larger SDDC might change your overall data center strategies. SQL Server is a good example. Does moving SQL Server virtual machines between clusters require licensing SQL to run on additional nodes?

## Scale-out file server and cluster sets

In Windows Server 2019, there is a new scale-out file server role called Infrastructure Scale-Out File Server (SOFS).

The following considerations apply to an Infrastructure SOFS role:

1. There can be at most only one Infrastructure SOFS cluster role on a Failover Cluster. Infrastructure SOFS role is created by specifying the "**-Infrastructure**" switch parameter to the **Add-ClusterScaleOutFileServerRole** cmdlet. For example:

    ```PowerShell
    Add-ClusterScaleoutFileServerRole -Name "my_infra_sofs_name" -Infrastructure
    ```

2. Each CSV volume created in the failover automatically triggers the creation of an SMB Share with an auto-generated name based on the CSV volume name. An administrator cannot directly create or modify SMB shares under an SOFS role, other than via CSV volume create/modify operations.

3. In hyper-converged configurations, an Infrastructure SOFS allows an SMB client (Hyper-V host) to communicate with guaranteed Continuous Availability (CA) to the Infrastructure SOFS SMB server. This hyper-converged SMB loopback CA is achieved via virtual machines accessing their virtual disk (VHDx) files where the owning virtual machine identity is forwarded between the client and server. This identity forwarding allows ACL-ing VHDx files just as in standard hyper-converged cluster configurations as before.

Once a cluster set is created, the cluster set namespace relies on an Infrastructure SOFS on each of the member clusters, and additionally an Infrastructure SOFS in the management cluster.

At the time a member cluster is added to a cluster set, the administrator specifies the name of an Infrastructure SOFS on that cluster if one already exists. If the Infrastructure SOFS does not exist, a new Infrastructure SOFS role on the new member cluster is created by this operation. If an Infrastructure SOFS role already exists on the member cluster, the Add operation implicitly renames it to the specified name as needed. Any existing singleton SMB servers, or non-Infrastructure SOFS roles on the member clusters are left unutilized by the cluster set.

At the time the cluster set is created, the administrator has the option to use an already-existing AD computer object as the namespace root on the management cluster. Cluster set creation operations create the Infrastructure SOFS cluster role on the management cluster or renames the existing Infrastructure SOFS role just as previously described for member clusters. The Infrastructure SOFS on the management cluster is used as the cluster set namespace referral (Cluster Set Namespace) SOFS. It simply means that each SMB Share on the cluster set namespace SOFS is a referral share – of type 'SimpleReferral' - newly introduced in Windows Server 2019. This referral allows SMB clients access to the target SMB share hosted on the member cluster SOFS. The cluster set namespace referral SOFS is a light-weight referral mechanism and as such, does not participate in the I/O path. The SMB referrals are cached perpetually on the each of the client nodes and the cluster sets namespace dynamically updates automatically these referrals as needed

## Create a cluster set

### Prerequisites

When creating a cluster set, consider the following prerequisites:

1. Configure a management client running Windows Server 2019.
2. Install the Failover Cluster tools on this management server.
3. Create cluster members (at least two clusters with at least two Cluster Shared Volumes on each cluster)
4. Create a management cluster (physical or guest) that straddles the member clusters. This approach ensures that the Cluster sets management plane continues to be available despite possible member cluster failures.

### Steps

1. Create a new cluster set from three clusters as defined in the prerequisites. The below chart gives an example of clusters to create. The name of the cluster set in this example will be **CSMASTER**.

   | Cluster Name | Infrastructure SOFS Name to be used later |
   |--------------|-------------------------------------------|
   | SET-CLUSTER  | SOFS-CLUSTERSET                           |
   | CLUSTER1     | SOFS-CLUSTER1                             |
   | CLUSTER2     | SOFS-CLUSTER2                             |

2. Once all the clusters have been created, use the following command to create the cluster set master:

    ```PowerShell
    New-ClusterSet -Name CSMASTER -NamespaceRoot SOFS-CLUSTERSET -CimSession SET-CLUSTER
    ```

3. Use the command set below to add a Cluster Server to the cluster set:

    ```PowerShell
    Add-ClusterSetMember -ClusterName CLUSTER1 -CimSession CSMASTER -InfraSOFSName SOFS-CLUSTER1
    Add-ClusterSetMember -ClusterName CLUSTER2 -CimSession CSMASTER -InfraSOFSName SOFS-CLUSTER2
    ```

   > [!NOTE]
   > If you are using a static IP Address scheme, you must include *-StaticAddress x.x.x.x* on the **New-ClusterSet** command.

4. Once you have created the cluster set out of cluster members, you can list the nodes set and its properties. To enumerate all the member clusters in the cluster set:

    ```PowerShell
    Get-ClusterSetMember -CimSession CSMASTER
    ```

5. To enumerate all the member clusters in the cluster set including the management cluster nodes:

    ```PowerShell
    Get-ClusterSet -CimSession CSMASTER | Get-Cluster | Get-ClusterNode
    ```

6. To list all the nodes from the member clusters:

    ```PowerShell
    Get-ClusterSetNode -CimSession CSMASTER
    ```

7. To list all the resource groups across the cluster set:

    ```PowerShell
    Get-ClusterSet -CimSession CSMASTER | Get-Cluster | Get-ClusterGroup
    ```

8. To verify that the cluster set creation process created one SMB share (identified as Volume1, or whatever the CSV folder is labeled with, the ScopeName being the Infrastructure File Server name and the path as both) on the Infrastructure SOFS for each cluster member's CSV volume:

    ```PowerShell
    Get-SmbShare -CimSession CSMASTER
    ```

9. Cluster set debug logs can be collected for review. Both the cluster set and cluster debug logs can be gathered for all members and the management cluster:

    ```PowerShell
    Get-ClusterSetLog -ClusterSetCimSession CSMASTER -IncludeClusterLog -IncludeManagementClusterLog -DestinationFolderPath <path>
    ```

10. Configure Kerberos [constrained delegation](https://techcommunity.microsoft.com/t5/virtualization/live-migration-via-constrained-delegation-with-kerberos-in/ba-p/382334) between all cluster set members.

11. Configure the cross-cluster virtual machine live migration authentication type to Kerberos on each node in the Cluster Set.

    ```PowerShell
    foreach($h in $hosts){ Set-VMHost -VirtualMachineMigrationAuthenticationType Kerberos -ComputerName $h }
    ```

12. Add the management cluster to the local administrators group on each node in the cluster set.

    ```PowerShell
    foreach($h in $hosts){ Invoke-Command -ComputerName $h -ScriptBlock {Net localgroup administrators /add <management_cluster_name>$} }
    ```

## Creating new VMs for a cluster set

After creating the cluster set, the next step is to create new VMs. You should perform the following checks beforehand:

- Available memory on the cluster nodes
- Available disk space on the cluster nodes
- Specific VM storage requirements in terms of speed and performance

Cluster sets place the VM on the most optimal node.

The below commands will identify the optimal cluster and deploy the VM to it. In the below example, a new VM is created as follows:

- 4 GB minimum available
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

When complete, you are shown where it was placed. In the above example, it would show as:

```
State         : Running
ComputerName  : 1-S2D2
```

If there is not enough memory, CPU capacity, or disk space available to add the VM, you will receive the following error:

```
Get-ClusterSetOptimalNodeForVM : A cluster node is not available for this operation.
```

Once the VM is created, it is displayed in Hyper-V manager on the specific node specified. To add it as a cluster set VM and add it to the cluster, use the command below:

```PowerShell
Register-ClusterSetVM -CimSession CSMASTER -MemberName $targetnode.Member -VMName CSVM1
```

When complete, the output will be:

```
Id  VMName  State  MemberName  PSComputerName
--  ------  -----  ----------  --------------
 1  CSVM1     On   CLUSTER1    CSMASTER
```

If you have created a cluster using existing VMs, the VMs need to be registered with the cluster set. To register all VMs at once, use:

```PowerShell
Get-ClusterSetMember -Name CLUSTER3 -CimSession CSMASTER | Register-ClusterSetVM -RegisterAll -CimSession CSMASTER
```

Next, add the VM path to cluster set namespace.

As an example, suppose an existing cluster is added with pre-configured VMs that reside on the local Cluster Shared Volume (CSV). The path for the VHDX would be something similar to `C:\ClusterStorage\Volume1\MYVM\Virtual Hard Disks\MYVM.vhdx1`. A storage migration would need to be accomplished, as CSV paths are by design local to a single member cluster and will therefore not be accessible to the VM once they are live migrated across member clusters.

In this example, CLUSTER3 was added to the cluster set using `Add-ClusterSetMember` with the Infrastructure Scale-Out File Server as SOFS-CLUSTER3. To move the VM configuration and storage, the command is:

```PowerShell
Move-VMStorage -DestinationStoragePath \\SOFS-CLUSTER3\Volume1 -Name MYVM
```

Once complete, you will receive a warning:

```
WARNING: There were issues updating the virtual machine configuration that may prevent the virtual machine from running. For more information view the report file below.
WARNING: Report file location: C:\Windows\Cluster\Reports\Update-ClusterVirtualMachineConfiguration '' on date at time.htm.
```

This warning can be ignored as the warning is "No changes in the virtual machine role storage configuration were detected". The reason for the warning is that the actual physical location does not change; only the configuration paths do.

For more information on `Move-VMStorage`, see [Move-VMStorage](../powershell/module/hyper-v/move-vmstorage.md).

Live migrating a VM between different clusters in the set is not the same as in the past. In non-cluster set scenarios, the steps would be:

1. remove the virtual machine role from the cluster.
2. live migrate the virtual machine to a member node of a different cluster.
3. add the virtual machine into the cluster as a new virtual machine role.

With cluster sets these steps are not necessary and only one command is needed. First, you should set all networks to be available for the migration with the command:

```PowerShell
Set-VMHost -UseAnyNetworkForMigration $true
```

For example, to move a cluster set VM from CLUSTER1 to NODE2-CL3 on CLUSTER3, the command would be:

```PowerShell
Move-ClusterSetVM -CimSession CSMASTER -VMName CSVM1 -Node NODE2-CL3
```

Note that this does not move the VM storage or configuration files. This is not necessary as the path to the VM remains as \\\\SOFS-CLUSTER1\VOLUME1. Once a VM has been registered with cluster sets with the infrastructure file server share path, the drives and VM do not require being on the same server as the VM.

## Availability sets and fault domains

Azure-like fault domains and availability sets can be configured in a cluster set. This is beneficial for initial VM placements and migrations between clusters.

In the example below, there are four clusters in the cluster set. Within the set, a logical fault domain is created with two of the clusters and a fault domain created with the other two clusters. These two fault domains will comprise the availability set.

In the example below, CLUSTER1 and CLUSTER2 are in the fault domain **FD1** and CLUSTER3 and CLUSTER4 are in the fault domain **FD2**. The availability set is **CSMASTER-AS** and comprised of the two fault domains.

To create the fault domains, the commands are:

```PowerShell
New-ClusterSetFaultDomain -Name FD1 -FdType Logical -CimSession CSMASTER -MemberCluster CLUSTER1,CLUSTER2 -Description "First fault domain"

New-ClusterSetFaultDomain -Name FD2 -FdType Logical -CimSession CSMASTER -MemberCluster CLUSTER3,CLUSTER4 -Description "Second fault domain"
```

To ensure they have been created successfully, `Get-ClusterSetFaultDomain` can be run with its output shown:

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

When creating new VMs, use the `-AvailabilitySet` parameter to determine the optimal node. So it would then look something like this:

```PowerShell
# Identify the optimal node to create a new VM
$memoryinMB=4096
$vpcount = 1
$av = Get-ClusterSetAvailabilitySet -Name CSMASTER-AS -CimSession CSMASTER
$targetnode = Get-ClusterSetOptimalNodeForVM -CimSession CSMASTER -VMMemory $memoryinMB -VMVirtualCoreCount $vpcount -VMCpuReservation 10 -AvailabilitySet $av
$secure_string_pwd = convertto-securestring "<password>" -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential ("<domain\account>",$secure_string_pwd)
```

## Removing a cluster from a set

There are times when a cluster needs to be removed from a cluster set. As a best practice, all cluster set VMs should be moved out of the cluster. This can be done using the `Move-ClusterSetVM` and `Move-VMStorage` commands.

If the VMs are not be moved out of the cluster, the cluster set runs a series of actions to provide an intuitive outcome to the administrator. When the cluster is removed from the set, all remaining cluster set VMs hosted on the cluster being removed will simply become highly available VMs bound to that cluster, assuming they have access to their storage. Cluster sets also automatically update their inventory by:

- No longer tracking the health of the now-removed cluster and the VMs running on it
- Removing namespace and all references to shares hosted on the now-removed cluster

For example, the command to remove the CLUSTER1 cluster from a cluster set is:

```PowerShell
Remove-ClusterSetMember -ClusterName CLUSTER1 -CimSession CSMASTER
```

## Cluster set namespace

A cluster set namespace is provided via a Continuously Available (CA) referral SOFS namespace server running on the management cluster. Use enough VMs from member clusters to make it resilient to localized cluster-wide failures. The referral information is also persistently cached in each cluster set node, even during reboots.

The cluster set namespace offers an overlay referral namespace within a cluster set similiar to the Distributed File System Namespace (DFSN). Unlike DFSN however, all cluster set namespace referral metadata is auto-populated on all nodes without any intervention, so there is almost no performance overhead in the storage access path.

The system state backup will backup the cluster state and metadata as well. Using Windows Server Backup, you can do restore just a node's cluster database if needed or do an authoritative restore to roll back the entire cluster database across all nodes. In the case of cluster sets, we recommend doing an authoritative restore first for the member clusters and then for the management cluster.

## Next steps

- Learn more about [Storage Replica]()
- Learn more about [Stretched clusters]()