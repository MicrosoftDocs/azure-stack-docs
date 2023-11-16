---
title: Create an Azure Stack HCI cluster using Windows PowerShell
description: Learn how to create a cluster for Azure Stack HCI using Windows PowerShell
author: ronmiab
ms.topic: how-to
ms.date: 11/16/2023
ms.author: robess
ms.reviewer: robhind
---
# Create an Azure Stack HCI cluster using Windows PowerShell

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, you learn how to use Windows PowerShell to create an Azure Stack HCI hyperconverged cluster that uses Storage Spaces Direct. If you're rather use the Cluster Creation wizard in Windows Admin Center to create the cluster, see [Create the cluster with Windows Admin Center](create-cluster.md).

> [!NOTE]
> If you're doing a single server installation of Azure Stack HCI 21H2, use PowerShell to create the cluster.

You have a choice between two cluster types:

- Standard cluster with one or two server nodes, all residing in a single site.
- Stretched cluster with at least four server nodes that span across two sites, with two nodes per site.

For the single server scenario, complete the same instructions for the one server.

> [!NOTE]
> Stretch clusters are not supported in a single server configuration.

In this article, we create an example cluster named Cluster1 that is composed of four server nodes named Server1, Server2, Server3, and Server4.

For the stretched cluster scenario, we use ClusterS1 as the name and use the same four server nodes stretched across sites Site1 and Site2.

For more information about stretched clusters, see [Stretched clusters overview](../concepts/stretched-clusters.md).

To test Azure Stack HCI with minimal or no extra hardware, you can check out the [Azure Stack HCI Evaluation Guide](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/README.md). In this guide, we walk you through experiencing Azure Stack HCI using nested virtualization inside an Azure VM. Or try the [Create a VM-based lab for Azure Stack HCI](tutorial-private-forest.md) tutorial to create your own private lab environment using nested virtualization on a server of your choice to deploy VMs running Azure Stack HCI for clustering.

## Before you begin

Before you begin, make sure you:

- Read and understand the [Azure Stack HCI system requirements](../concepts/system-requirements.md).
- Read and understand the [Physical network requirements](../concepts/physical-network-requirements.md) and [Host network requirements](../concepts/host-network-requirements.md) for Azure Stack HCI.
- Install the Azure Stack HCI OS on each server in the cluster. See [Deploy the Azure Stack HCI operating system](operating-system.md).
- Ensure all servers are in the correct time zone.
- Have an account that's a member of the local Administrators group on each server.
- Have rights in Active Directory to create objects.
- For stretched clusters, set up your two sites beforehand in Active Directory.

## Using Windows PowerShell

You can either run PowerShell locally in an RDP session on a host server, or you can run PowerShell remotely from a management computer. This article covers the remote option.

When running PowerShell from a management computer, include the `-Name` or `-Cluster` parameter with the name of the server or cluster you're managing. In addition, you might need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

You need the Remote Server Administration Tools (RSAT) cmdlets and PowerShell modules for Hyper-V and Failover Clustering. If the cmdlets and modules aren't already available in your PowerShell session on your management computer, you can add them using the following command: `Add-WindowsFeature RSAT-Clustering-PowerShell`.

## Step 1: Set up the servers

First, connect to each of the servers, join them to a domain (the same domain the management computer is in), and install required roles and features.

### Step 1.1: Connect to the servers

To connect to the servers, you must first have network connectivity, be joined to the same domain or a fully trusted domain, and have local administrative permissions to the servers.

Open PowerShell and use either the fully-qualified domain name or the IP address of the server you want to connect to. You'll be prompted for a password after you run the following command on each server.

For this example, we assume that the servers are named Server1, Server2, Server3, and Server4:

   ```powershell
   Enter-PSSession -ComputerName "Server1" -Credential "Server1\Administrator"
   ```

Here's another example of doing the same thing:

   ```powershell
   $myServer1 = "Server1"
   $user = "$myServer1\Administrator"

   Enter-PSSession -ComputerName $myServer1 -Credential $user
   ```

> [!TIP]
> When running PowerShell commands from your management PC, you might get an error like *WinRM cannot process the request.* To fix this, use PowerShell to add each server to the Trusted Hosts list on your management computer. This list supports wildcards, like `Server*` for example.
>
> `Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value Server1 -Force`
>  
> To view your Trusted Hosts list, type `Get-Item WSMAN:\Localhost\Client\TrustedHosts`.  
>
> To empty the list, type `Clear-Item WSMAN:\Localhost\Client\TrustedHost`.  

### Step 1.2: Join the domain and add domain accounts

In the previous step you connected to each server node with, the local administrator account `<ServerName>\Administrator`.

To proceed, you must join the servers to a domain and use the domain account that is in the local Administrators group on every server.

Use the `Enter-PSSession` cmdlet to connect to each server and  run the following cmdlet, substituting the server name, domain name, and domain credentials:

```powershell  
Add-Computer -NewName "Server1" -DomainName "contoso.com" -Credential "Contoso\User" -Restart -Force  
```

If your administrator account isn't a member of the Domain Admins group, add your administrator account to the local Administrators group on each server - or better yet, add the group you use for administrators. You can use the following command to do so:

```powershell
Add-LocalGroupMember -Group "Administrators" -Member "king@contoso.local"
```

### Step 1.3: Install roles and features

The next step is to install required Windows roles and features on every server for the cluster. Here are the roles to install:

- BitLocker
- Data Center Bridging
- Failover Clustering
- File Server
- FS-Data-Deduplication module
- Hyper-V
- Hyper-V PowerShell
- RSAT-Clustering-PowerShell module
- RSAT-AD-PowerShell module
- NetworkATC
- NetworkHUD
- SMB Bandwidth Limit
- Storage Replica (for stretched clusters)

Use the following command for each server (if you're connected via Remote Desktop omit the `-ComputerName` parameter here and in subsequent commands):

```powershell
Install-WindowsFeature -ComputerName "Server1" -Name "BitLocker", "Data-Center-Bridging", "Failover-Clustering", "FS-FileServer", "FS-Data-Deduplication", "FS-SMBBW", "Hyper-V", "Hyper-V-PowerShell", "RSAT-AD-Powershell", "RSAT-Clustering-PowerShell", "NetworkATC", "NetworkHUD", "Storage-Replica" -IncludeAllSubFeature -IncludeManagementTools
```

To run the command on all servers in the cluster at the same time, use the following script, modifying the list of variables at the beginning to fit your environment:

```powershell
# Fill in these variables with your values
$ServerList = "Server1", "Server2", "Server3", "Server4"
$FeatureList = "BitLocker", "Data-Center-Bridging", "Failover-Clustering", "FS-FileServer", "FS-Data-Deduplication", "Hyper-V", "Hyper-V-PowerShell", "RSAT-AD-Powershell", "RSAT-Clustering-PowerShell", "NetworkATC", "NetworkHUD", "FS-SMBBW", "Storage-Replica"

# This part runs the Install-WindowsFeature cmdlet on all servers in $ServerList, passing the list of features in $FeatureList.
Invoke-Command ($ServerList) {
    Install-WindowsFeature -Name $Using:Featurelist -IncludeAllSubFeature -IncludeManagementTools
}
```

Next, restart all the servers:

```powershell
$ServerList = "Server1", "Server2", "Server3", "Server4"
Restart-Computer -ComputerName $ServerList -WSManAuthentication Kerberos
```

## Step 2: Prep for cluster setup

Next, verify that your servers are ready for clustering.

As a sanity check, consider running the following commands to make sure that your servers don't already belong to a cluster:

Use `Get-ClusterNode` to show all nodes:

```powershell
Get-ClusterNode
```

Use `Get-ClusterResource` to show all cluster nodes:

```powershell
Get-ClusterResource
```

Use `Get-ClusterNetwork` to show all cluster networks:

```powershell
Get-ClusterNetwork
```

### Step 2.1: Prepare drives

Before you enable Storage Spaces Direct, ensure your permanent drives are empty. Run the following script to remove any old partitions and other data.

> [!NOTE]
> Exclude any removable drives attached to a server node from the script. If you are running this script locally from a server node for example, you don't want to wipe the removable drive you might be using to deploy the cluster.

```powershell
# Fill in these variables with your values
$ServerList = "Server1", "Server2", "Server3", "Server4"

Invoke-Command ($ServerList) {
    Update-StorageProviderCache
    Get-StoragePool | ? IsPrimordial -eq $false | Set-StoragePool -IsReadOnly:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Get-VirtualDisk | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
    Get-PhysicalDisk | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    Get-Disk | ? Number -ne $null | ? IsBoot -ne $true | ? IsSystem -ne $true | ? PartitionStyle -ne RAW | % {
        $_ | Set-Disk -isoffline:$false
        $_ | Set-Disk -isreadonly:$false
        $_ | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
        $_ | Set-Disk -isreadonly:$true
        $_ | Set-Disk -isoffline:$true
    }
    Get-Disk | Where Number -Ne $Null | Where IsBoot -Ne $True | Where IsSystem -Ne $True | Where PartitionStyle -Eq RAW | Group -NoElement -Property FriendlyName
} | Sort -Property PsComputerName, Count
```

### Step 2.2: Test cluster configuration

In this step, ensure that the server nodes are configured correctly to create a cluster. The `Test-Cluster` cmdlet is used to run tests to verify your configuration is suitable to function as a hyperconverged cluster. The following example uses the `-Include` parameter, with the specific categories of tests specified to ensure that the correct tests are included in the validation.

```powershell
Test-Cluster -Node $ServerList -Include "Storage Spaces Direct", "Inventory", "Network", "System Configuration"
```

## Step 3: Create the cluster

You're now ready to create a cluster with the server nodes that you validated in the preceding steps.

When creating the cluster, you might get a warning that states - `"There were issues while creating the clustered role that may prevent it from starting. For more information, view the report file below."` You can safely ignore this warning. This warning is due to no disks being available for the cluster witness. The cluster witness is created in later steps.

> [!NOTE]
> If the servers are using static IP addresses, modify the following command to reflect the static IP address by adding the following parameter and specifying the IP address: `-StaticAddress <X.X.X.X>;`.

```powershell
$ClusterName="cluster1" 
New-Cluster -Name $ClusterName –Node $ServerList –nostorage
```

After the cluster is created, it can some take time for the cluster name to be replicated via DNS across your domain, especially if workgroup servers are newly added to Active Directory. Although the cluster might be displayed in Windows Admin Center, it might not be available to connect to yet.

A good check to ensure all cluster resources are online:

```powershell
Get-Cluster -Name $ClusterName | Get-ClusterResource
```

If resolving the cluster isn't successful after some time, in most cases you can connect by using the name of one of the clustered servers instead of the cluster name.

## Step 4: Configure host networking

Microsoft recommends using [Network ATC](./network-atc.md) to deploy host networking if you're running Azure Stack HCI version 21H2 or newer. Otherwise, see [Host network requirements](../concepts/host-network-requirements.md) for specific requirements and information.

Network ATC can automate the deployment of your intended networking configuration if you specify one or more intent types for your adapters. For more information on specific intent types, see: [Network Traffic Types](../concepts/host-network-requirements.md#network-traffic-types).

### Step 4.1: Review physical adapters

On one of the cluster nodes, run `Get-NetAdapter` to review the physical adapters. Ensure that each node in the cluster has the same named physical adapters and that they report status as 'Up'.

```powershell
Get-NetAdapter -Name pNIC01, pNIC02 -CimSession $ClusterName | Select Name, PSComputerName
```

If a physical adapter name varies across nodes in your cluster, you can rename it using `Rename-NetAdapter`.

```powershell
Rename-NetAdapter -Name oldName -NewName newName
```

### Step 4.2: Configure an intent

In this example, an intent is created that specifies the compute and storage intent. See [Simplify host networking with Network ATC](./network-atc.md) for more intent examples.

Run the following command to add the storage and compute intent types to pNIC01 and pNIC02. Note, we specify the `-ClusterName` parameter.

```powershell
Add-NetIntent -Name Cluster_ComputeStorage -Compute -Storage -ClusterName $ClusterName -AdapterName pNIC01, pNIC02
```

The command should immediately return after some initial verification.

### Step 4.3: Validate intent deployment

Run the `Get-NetIntent` cmdlet to see the cluster intent. If you have more than one intent, you can specify the `Name` parameter to see details of only a specific intent.

```powershell
Get-NetIntent -ClusterName $ClusterName
```

To see the provisioning status of the intent, run the `Get-NetIntentStatus` command:

```powershell
Get-NetIntentStatus -ClusterName $ClusterName -Name Cluster_ComputeStorage
```

Note the status parameter that shows Provisioning, Validating, Success, Failure.

The status should display success in a few minutes. If the success status doesn't occur or you see a status parameter failure, check the event viewer for issues.

> [!NOTE]
> At this time, Network ATC does not configure IP addresses for any of its managed adapters. Once `Get-NetIntentStatus` reports status completed, you should add IP addresses to the adapters.

## Step 5: Set up sites (stretched cluster)

This task only applies if you're creating a stretched cluster between two sites with at least two servers in each site.

> [!NOTE]
> If you have set up Active Directory Sites and Services beforehand, you don't need to create the sites manually as described in the next section.

### Step 5.1: Create sites

In the following cmdlet, *FaultDomain* is simply another name for a site. This example uses "ClusterS1" as the name of the stretched cluster.

```powershell
New-ClusterFaultDomain -CimSession $ClusterName -FaultDomainType Site -Name "Site1"
```

```powershell
New-ClusterFaultDomain -CimSession $ClusterName -FaultDomainType Site -Name "Site2"
```

Use the `Get-ClusterFaultDomain` cmdlet to verify that both sites are created for the cluster.

```powershell
Get-ClusterFaultDomain -CimSession $ClusterName
```

### Step 5.2: Assign server nodes

Next, we assign the four server nodes to their respective sites. In the following example, Server1 and Server2 are assigned to Site1, while Server3 and Server4 are assigned to Site2.

```powershell
Set-ClusterFaultDomain -CimSession $ClusterName -Name "Server1", "Server2" -Parent "Site1"
```

```powershell
Set-ClusterFaultDomain -CimSession $ClusterName -Name "Server3", "Server4" -Parent "Site2"
```

Using the `Get-ClusterFaultDomain` cmdlet, verify the nodes are in the correct sites.

```powershell
Get-ClusterFaultDomain -CimSession $ClusterName
```

### Step 5.3: Set a preferred site

You can also define a global *preferred* site, which means that specified resources and groups must run on the preferred site.  This setting can be defined at the site level using the following command:  

```powershell
(Get-Cluster).PreferredSite = "Site1"
```

Specifying a preferred Site for stretched clusters has the following benefits:

- **Cold start** - during a cold start, virtual machines are placed in the preferred site

- **Quorum voting**
  - With a dynamic quorum, weighting is decreased from the passive (replicated) site first to ensure that the preferred site survives if all other things are equal. In addition, server nodes are pruned from the passive site first during regrouping after events such as asymmetric network connectivity failures.

  - During a quorum split of two sites, if the cluster witness can't be contacted, the preferred site is automatically elected to win. The server nodes in the passive site then drop out of cluster membership allowing the cluster to survive a simultaneous 50% loss of votes.

The preferred site can also be configured at the cluster role or group level. In this case, a different preferred site can be configured for each virtual machine group enabling a site to be active and preferred for specific virtual machines.

### Step 5.4: Set up Stretch Clustering with Network ATC

After version 22H2, you can use Network ATC to set up Stretch clustering. Network ATC adds Stretch as an intent type from version 22H2. To deploy an intent with Stretch clustering with Network ATC, run the following command:

```powershell
Add-NetIntent -Name StretchIntent -Stretch -AdapterName "pNIC01", "pNIC02"
```

A stretch intent can also be combined with other intents, when deploying with Network ATC.

#### SiteOverrides

Based on steps 5.1-5.3 you can add your pre-created sites to your stretch intent deployed with Network ATC. Network ATC handles this using SiteOverrides. To create a SiteOverride, run:

```powershell
 $siteOverride = New-NetIntentSiteOverrides
```

Once your siteOverride is created, you can set any property for the siteOverride. Make sure that the name property of the siteOverride has the exact same name, as the name your site has in the ClusterFaultDomain. A mismatch of names between the ClusterFaultDomain and the siteOverride results in the siteOverride not being applied.

The properties you can set for a particular siteOverride are: Name, StorageVlan and StretchVlan. For example, you create 2 siteOverrides for your two sites- site1 and site2 using:

```powershell
$siteOverride1 = New-NetIntentSiteOverrides
$siteoverride1.Name = "site1"
$siteOverride1.StorageVLAN = 711
$siteOverride1.StretchVLAN = 25

$siteOverride2 = New-NetIntentSiteOverrides
$siteOverride2.Name = "site2"
$siteOverride2.StorageVLAN = 712
$siteOverride2.StretchVLAN = 26
```

You can run `$siteOverride1`, `$siteOverride2` in your PowerShell window to make sure all your properties are set in the desired manner.

Finally, to add one or more siteOverrides to your intent, run:

```powershell
Add-NetIntent -Name StretchIntent -Stretch -AdapterName "pNIC01" , "pNIC02" -SiteOverrides $siteOverride1, $siteOverride2
```

## Step 6: Enable Storage Spaces Direct

After creating the cluster, use the `Enable-ClusterStorageSpacesDirect` cmdlet, which will enable Storage Spaces Direct and do the following automatically:

- **Create a storage pool:** Creates a storage pool for the cluster that has a name like "Cluster1 Storage Pool".

- **Create a Cluster Performance History disk:** Creates a Cluster Performance History virtual disk in the storage pool.

- **Create data and log volumes:** Creates a data volume and a log volume in the storage pool.

- **Configure Storage Spaces Direct caches:** If there's more than one media (drive) type available for Storage Spaces Direct, it enables the fastest as cache devices (read and write in most cases).

- **Create tiers:** Creates two tiers as default tiers. One is called "Capacity" and the other called "Performance". The cmdlet analyzes the devices and configures each tier with the mix of device types and resiliency.

For the single server scenario, the only FaultDomainAwarenessDefault is PhysicalDisk. `Enable-ClusterStorageSpacesDirect` cmdlet detects a single server and automatically configures FaultDomainAwarenessDefault as a PhysicalDisk during enablement.

For stretched clusters, the `Enable-ClusterStorageSpacesDirect` cmdlet will also:

- Check to see if sites are set up
- Determine which nodes are in which sites
- Determines what storage each node has available
- Checks to see if the Storage Replica feature is installed on each node
- Creates a storage pool for each site and identifies it with the name of the site
- Creates data and log volumes in each storage pool - one per site

The following command enables Storage Spaces Direct on a multi-node cluster. You can also specify a friendly name for a storage pool, as shown here:

```powershell
Enable-ClusterStorageSpacesDirect -PoolFriendlyName "$ClusterName Storage Pool" -CimSession $ClusterName
```

Here's an example of disabling the storage cache, on a single-node cluster:

```powershell
Enable-ClusterStorageSpacesDirect -CacheState Disabled
```

To see the storage pools, use the following command:

```powershell
Get-StoragePool -CimSession $ClusterName
```

## After you create the cluster

Now that your cluster is created, there are other important tasks you need to complete:

- Set up a cluster witness if you're using a two-node or larger cluster. See [Set up a cluster witness](../manage/witness.md).
- Create your volumes. See [Create volumes](../manage/create-volumes.md).
When creating volumes on a single-node cluster, you must use PowerShell. See [Create volumes using PowerShell](../manage/create-volumes.md#create-volumes-using-windows-powershell).
- For stretched clusters, create volumes and set up replication using Storage Replica. See [Create volumes and set up replication for stretched clusters](../manage/create-stretched-volumes.md).

## Next steps

- Register your cluster with Azure. See [Connect Azure Stack HCI to Azure](register-with-azure.md).
- Do a final validation of the cluster. See [Validate an Azure Stack HCI cluster](validate.md)
- Manage host networking. See [Manage host networking using Network ATC](../manage/manage-network-atc.md).
