---
title: Create an Azure Stack HCI cluster using Windows PowerShell
description: Learn how to create a hyperconverged cluster for Azure Stack HCI using Windows PowerShell
author: v-dasis
ms.topic: article
ms.prod: 
ms.date: 06/10/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---
# Create an Azure Stack HCI cluster using Windows PowerShell

> Applies to: Azure Stack HCI v20H2

In this article you will learn how to use Windows PowerShell to create an Azure Stack HCI hyperconverged cluster that uses Storage Spaces Direct.

You have a choice between two cluster types:

- Standard cluster with at least two server nodes, all residing in a single site.
- Stretched cluster with at least four server nodes that span across two sites, with two nodes per site.

In this article, we will create an example cluster named Cluster1 that is comprised of four server nodes named Server1, Server2, Server3, and Server4. 

For the stretched cluster scenario, we will use ClusterS1 as the name and use the same four server nodes stretched across sites Site1 and Site2.

## Before you begin

Here are several requirements before you begin:

- Make sure you have reviewed hardware requirements and considerations in [Planning a cluster].

- You should run Windows Admin Center from a remote computer running Windows 10, rather than from a host server in the cluster. This remote computer is called the management computer.

- You must have administrative privileges for the cluster. Use an account that’s a member of the local Administrators group on each server.

- Each server you want to add to the cluster, as well as the management computer, must all be joined to the same Active Directory domain or fully trusted domain.

## Using Windows PowerShell

When running PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the server or cluster you are managing. In addition, you may need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

You will also need the Remote Server Administration Tools (RSAT) cmdlets and PowerShell modules for Hyper-V and Failover Clustering. If these aren't already available in your PowerShell session on your management computer, you can add them using the following command: `Add-WindowsFeature RSAT-Clustering-PowerShell`.

> [!NOTE]
> Starting with Windows 10 October 2018 Update, RSAT is included as a set of "Features on Demand" right from Windows 10. Simply go to **Settings > Apps > Apps & features > Optional features > Add a feature > RSAT: Failover Clustering Tools**, and select **Install**. To see installation progress, click the Back button to view status on the **Manage optional features** page. Once installed, RSAT will persist across Windows 10 version upgrades.

## Step 1: Provision the servers

First we will connect to each of the servers, join them to a domain (the same domain the management computer is in), and install required roles and features.

### Step 1.1: Connect to the servers

To connect to the servers, you must first have network connectivity, be joined to the same domain or a fully trusted domain, and have local administrative permissions to the servers.

Open PowerShell and use either the fully-qualified domain name or the IP address of the server you want to connect to. You'll be prompted for a password after you run the following command on each server (Server1, Server2, Server3, Server4):

   ```powershell
   Enter-PSSession -ComputerName Server1 -Credential Server1\Administrator
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

So far you've connected to each server node with the local administrator account `<ServerName>\Administrator`.

To proceed, you'll need to join the servers to a domain and use the domain account that is in the local Administrators group on every server.

Use the `Enter-PSSession` cmdlet to connect to each server and  run the following cmdlet, substituting the server name, domain name, and domain credentials:

```powershell  
Add-Computer -NewName "Server1" -DomainName "contoso.com" -Credential "Contoso\User" -Restart -Force  
```

If your administrator account isn't a member of the Domain Admins group, add your administrator account to the local Administrators group on each server - or better yet, add the group you use for administrators. You can use the following command to do so:

```powershell
Net localgroup Administrators <Domain\Account> /add
```

### Step 1.3: Install roles and features

The next step is to install required Windows roles and features on every server for the cluster. Here are the roles to install:

- BitLocker
- Data Center Bridging (for RoCEv2 network adapters)
- Failover Clustering
- File Server (for file-share witness or hosting file shares)
- FS-Data-Deduplication module
- Hyper-V
- RSAT-AD-PowerShell module
- Storage Replica (only for stretched clusters)

Use the following command for each server:

```powershell
Install-WindowsFeature -ComputerName Server1 -Name "BitLocker", "Data-Center-Bridging", "Failover-Clustering  -IncludeAllSubFeature -IncludeManagementTools", "FS-FileServer", "Hyper-V", "Hyper-V-PowerShell", "RSAT-Clustering-PowerShell", "Storage-Replica"
```

To run the command on all servers in the cluster as the same time, use the following script, modifying the list of variables at the beginning to fit your environment.

```powershell
# Fill in these variables with your values
$ServerList = "Server1", "Server2", "Server3", "Server4"
$FeatureList = "BitLocker", "Data-Center-Bridging", "Failover-Clustering -IncludeAllSubFeature -IncludeManagementTools", "FS-FileServer", "Hyper-V", "Hyper-V-PowerShell", "RSAT-Clustering-PowerShell", "Storage-Replica"

# This part runs the Install-WindowsFeature cmdlet on all servers in $ServerList, passing the list of features in $FeatureList.
Invoke-Command ($ServerList) {
    Install-WindowsFeature -Name $Using:Featurelist
}
```
Next, restart all the servers:

```powershell
$ServerList = "Server1", "Server2", "Server3", "Server4"
Restart-Computer -ComputerName $ServerList
```

## Step 2: Configure the network

### Disable unused networks

You must disable any networks disconnected or not used for management, storage or workload traffic (such as VMs). Here is how to identify unused networks:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
Get-NetAdapter -CimSession $Servers | Where-Object Status -eq Disconnected
```
And here is how to disable them:

```powershell
Get-NetAdapter -CimSession $Servers | Where-Object Status -eq Disconnected | Disable-NetAdapter -Confirm:$False
```

### Assign virtual network adapters

Next, you will assign virtual network adapters (vNICs) dedicated for management and storage, as in the example:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$vSwitchName="vSwitch"
Rename-VMNetworkAdapter -ManagementOS -Name $vSwitchName -NewName Management -ComputerName $Servers
Add-VMNetworkAdapter -ManagementOS -Name SMB01 -SwitchName $vSwitchName -CimSession $Servers
Add-VMNetworkAdapter -ManagementOS -Name SMB02 -SwitchName $vSwitchName -Cimsession $Servers
```

And verify they have been successfully added and assigned:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
Get-VMNetworkAdapter -CimSession $Servers -ManagementOS
```

### Create virtual switches

A virtual switch is needed for each server node in your cluster. In the following example, a virtual switch with SR-IOV capability is created using network adapters that are connected (Status is UP). SR-IOV enabled might be useful as it's required for RDMA enabled vmNICs (vNICs for VMs).

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$vSwitchName="vSwitch"

#Create virtual switch
Invoke-Command -ComputerName $Servers -ScriptBlock {New-VMSwitch -Name $using:vSwitchName -EnableEmbeddedTeaming $TRUE -EnableIov $true -NetAdapterName (Get-NetAdapter | Where-Object Status -eq Up ).InterfaceAlias}
```

Now, validate that the switch has been successfully created:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
Get-VMSwitch -CimSession $Servers | Select-Object Name, IOVEnabled, IOVS*
Get-VMSwitchTeam -CimSession $Servers
```

### Configure VLANs and IP addresses

You can configure either one or two subnets. Two subnets are preferred if you want to prevent overloading of the switch interconnect. For example, SMB storage traffic will stay on a subnet that's dedicated to one physical switch.

#### Configure one subnet

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$StorNet="172.16.1."
$StorVLAN=1
$IP=1 #starting IP Address

#Configure IP Addresses
foreach ($Server in $Servers){
    New-NetIPAddress -IPAddress ($StorNet+$IP.ToString()) -InterfaceAlias "vEthernet (SMB01)" -CimSession $Server -PrefixLength 24
    $IP++
    New-NetIPAddress -IPAddress ($StorNet+$IP.ToString()) -InterfaceAlias "vEthernet (SMB02)" -CimSession $Server -PrefixLength 24
    $IP++
}

#Configure VLANs
Set-VMNetworkAdapterVlan -VMNetworkAdapterName SMB01 -VlanId $StorVLAN -Access -ManagementOS -CimSession $Servers
Set-VMNetworkAdapterVlan -VMNetworkAdapterName SMB02 -VlanId $StorVLAN -Access -ManagementOS -CimSession $Servers
#Restart each host vNIC adapter so that the Vlan is active.
Restart-NetAdapter "vEthernet (SMB01)" -CimSession $Servers
Restart-NetAdapter "vEthernet (SMB02)" -CimSession $Servers
 
```

#### Configure two subnets

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$StorNet1="172.16.1."
$StorNet2="172.16.2."
$StorVLAN1=1
$StorVLAN2=2
$IP=1 #starting IP Address

#Configure IP Addresses
foreach ($Server in $Servers){
    New-NetIPAddress -IPAddress ($StorNet1+$IP.ToString()) -InterfaceAlias "vEthernet (SMB01)" -CimSession $Server -PrefixLength 24
    New-NetIPAddress -IPAddress ($StorNet2+$IP.ToString()) -InterfaceAlias "vEthernet (SMB02)" -CimSession $Server -PrefixLength 24
    $IP++
}

#Configure VLANs
Set-VMNetworkAdapterVlan -VMNetworkAdapterName SMB01 -VlanId $StorVLAN1 -Access -ManagementOS -CimSession $Servers
Set-VMNetworkAdapterVlan -VMNetworkAdapterName SMB02 -VlanId $StorVLAN2 -Access -ManagementOS -CimSession $Servers
#Restart each host vNIC adapter so that the Vlan is active.
Restart-NetAdapter "vEthernet (SMB01)" -CimSession $Servers
Restart-NetAdapter "vEthernet (SMB02)" -CimSession $Servers
```

#### Verify VLAN IDs and subnets

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
#verify ip config
Get-NetIPAddress -CimSession $servers -InterfaceAlias vEthernet* -AddressFamily IPv4 | Sort-Object -Property PSComputername | ft pscomputername,interfacealias,ipaddress -AutoSize -GroupBy PSComputerName

#Verify that the VlanID is set
Get-VMNetworkAdapterVlan -ManagementOS -CimSession $servers | Sort-Object -Property Computername | Format-Table ComputerName,AccessVlanID,ParentAdapter -AutoSize -GroupBy ComputerName

```

```powershell
Get-VMSwitch | FL
```

## Step 3: Verify cluster setup

Next, you must first verify that your servers are prepared and configured properly for cluster creating.

### Step 3.1: Prepare drives

Before you enable Storage Spaces Direct later on, ensure your drives are empty. Run the following script to remove any old partitions or other data.

> [!WARNING]
> This script will permanently remove any data on any drives other than the Azure Stack HCI system boot drive.

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

### Step 3.2: Test cluster setup

In this step, you'll ensure that the server nodes are configured correctly to create a cluster. The `Test-Cluster` cmdlet is used to run tests to verify your configuration is suitable to function as a hyperconverged cluster. The example below uses the `-Include` parameter, with the specific categories of tests specified. This ensures that the correct tests are included in the validation.

```powershell
Test-Cluster -Cluster –Node Server1, Server2, Server3, Server4 –Include "Storage Spaces Direct", "Inventory", "Network", "System Configuration"
```

## Step 4: Create the cluster

You are now ready to create a cluster with the server nodes that you have validated in the preceding steps.

When creating the cluster, you'll get a warning that states - `"There were issues while creating the clustered role that may prevent it from starting. For more information, view the report file below."` You can safely ignore this warning. It's due to no disks being available for the cluster witness that you will create later. 

> [!NOTE]
> If the servers are using static IP addresses, modify the following command to reflect the static IP address by adding the following parameter and specifying the IP address: `–StaticAddress <X.X.X.X>;`.

> ```powershell
> New-Cluster –Name Cluster1 –Node Server1, Server2, Server3, Server4 –NoStorage
> ```

Congrats, your cluster has now been created.

> [!NOTE]
> After the cluster is created, it can take time for the cluster name to be replicated. If resolving the cluster isn't successful, in most cases you can substitute the computer name of a server node in the the cluster instead of the cluster name.

## Step 5: Setup sites (stretched cluster)

This task only applies if you are creating a stretched cluster that spans two sites.

In the cmdlet below, *FaultDomain* is simply another name for a site. This example uses `ClusterS1` as the name of the stretched cluster.

```powershell
New-ClusterFaultDomain -CimSession ClusterS1 -Type Site -Name Site1
```

```powershell
New-ClusterFaultDomain -CimSession ClusterS1 -Type Site -Name Site2
```

Use the `Get-ClusterFaultDomain` cmdlet to verify that both sites have been created for the cluster.

```powershell
Get-ClusterFaultDomain
```

Next, we will assign the four server nodes to their respective sites. In the example below, Server1 and Server2 are assigned to Site1, while Server3 and Server4 are assigned to Site2.

```powershell
Set-ClusterFaultDomain -CimSession ClusterS1 -Name Server1, Server2 -Parent Site1
```

```powershell
Set-ClusterFaultDomain -CimSession ClusterS1 -Name Server3, Server4 -Parent Site2
```

Using the `Get-ClusterFaultDomain` cmdlet, verify the nodes are in the correct sites. Note that all the nodes are "children" of their sites based on subnet.

```powershell
Get-ClusterFaultDomain -CimSession ClusterS1
```

## Step 6: Enable Storage Spaces Direct

After creating the cluster, use the `Enable-ClusterStorageSpacesDirect` cmdlet, which will enable Storage Spaces Direct and do the following automatically:

- **Create a pool:** Creates a storage pool for the cluster that has a name like "Cluster1 Storage Pool".

- **Configures the Storage Spaces Direct caches:** If there is more than one media (drive) type available for Storage Spaces Direct, it enables the fastest as cache devices (read and write in most cases)

- **Tiers:** Creates two tiers as default tiers. One is called "Capacity" and the other called "Performance". The cmdlet analyzes the devices and configures each tier with the mix of device types and resiliency.

The following command enables Storage Spaces Direct:

```powershell
New-CimSession -Cluster Cluster1 | Enable-ClusterStorageSpacesDirect -PoolFriendlyName 'Cluster1 Storage Pool'
```

> [!NOTE]
You can also use a server node name instead of the cluster name above. Using the server name can be more reliable due to DNS replication delays that may occur with the newly created cluster name.

## Step 7: Create a witness

Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline

You can use an Azure cloud witness or a file share as a witness. A cloud witness is recommended.

### Step 6.1: Configure a cloud witness

Use the following to create an Azure cloud witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -CloudWitness -AccountName <AzureStorageAccountName> -AccessKey <AzureStorageAccountAccessKey>
```

### Step 6.2: Configure a file share witness

Use the following to create a file-share witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -FileShareWitness \\fileserver\fsw
```

## Step 7: Create volumes

Volume creation is different for single-site clusters versus stretched (two-site) clusters. For both scenarios however, you can use the `New-Volume` cmdlet to create a virtual disk, partition and format it, create a volume with matching name, and add it to cluster shared volumes (CSV) – all in one easy step.

### Create volumes for single-site clusters

If you have a standard single-site cluster, do this for each of your server nodes:

```powershell
New-Volume -CimSession Server1 -FriendlyName Disk1 -FileSystem REFS -DriveLetter F -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Cluster1"
```

**<== add more stuff**

### Create volumes for stretched clusters

Creating volumes and virtual disks for stretched clusters is a bit more involved than for single-site clusters. Stretched clusters require a minimum of four volumes - two data volumes and two log volumes, with a data/log volume pair residing in each site. Then you will create a replication group for each site, and setup replication between them.

There are two types of stretched clusters, active/passive and active/active.
You can set up active-passive site replication, where there is a preferred site and direction for replication. Active-active replication is where replication can happen bi-directionally from either site. This article covers the active/passive configuration only.

### Active/passive stretched cluster

The following diagram shows Site 1 as the active site with replication to Site 2, a unidirectional replication.

:::image type="content" source="media/cluster/stretch-active-passive.png" alt-text="Active/passive stretched cluster scenario":::

### Active/active stretched cluster

The following diagram shows both Site 1 and Site 2 as being active sites, with bidirectional replication to the other site.

:::image type="content" source="media/cluster/stretch-active-active.png" alt-text="Active/active stretched cluster scenario":::

OK, now we are ready to begin. We first need to move resource groups around from node to node. The `Move-ClusterGroup` cmdlet is used to this.

> [!TIP]
> Moving a resource group is also a way of simulating failover between nodes.

First we move the "Available Storage" storage pool resource group to node Server1 in Site1 using the `Move-ClusterGroup` cmdlet:

```powershell
Move-ClusterGroup -Cluster ClusterS1 -Name ‘Available Storage’ -Node Server1
```

Next, create the first virtual disk (Disk1) for node Server1 on site Site1:

```powershell
New-Volume -CimSession Server1 -FriendlyName Disk1 -FileSystem REFS -DriveLetter F -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 1"
```

Create a second first virtual disk (Disk2) for node Server1:

```powershell
New-Volume -CimSession Server1 -FriendlyName Disk2 -FileSystem REFS -DriveLetter G -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 1"
```

Now, take the "Available Storage" group offline:

```powershell
Stop-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage'
```

And move the "Available Storage" group to node Server3 in Site2:

```powershell
Move-ClusterGroup -Name 'Available Storage' -Node Server3
```

Create the first virtual disk (Disk3) on node Server3 in Site2:

```powershell
New-Volume -CimSession Server3 -FriendlyName Disk3 -FileSystem REFS -DriveLetter H -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 2"
```

And create a second virtual disk (Disk4) on node Server3:

```powershell
New-Volume -CimSession Server3 -FriendlyName Disk4 -FileSystem REFS -DriveLetter I -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 2"
```

Now take the `Available Storage` group offline and then move it back to one of the nodes in Site1:

```powershell
Stop-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage'
```

```powershell
Move-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage' -Node Server1
```

Using the `Get-ClusterResource` cmdlet, ensure that four virtual disk volumes were created, two in each storage pool:

```powershell
Get-ClusterResource -Cluster ClusterS1
```

Now add Disk1 to Cluster Shared Volumes:

```powershell
Add-ClusterSharedVolume -Name 'Cluster Virtual Disk (Disk1)'
```

### Enable the CSV cache (optional)

Finally and optionally, you can enable the CSV cache to use system memory (RAM) as a write-through block-level cache of read operations that aren't already cached by the Windows cache manager. This can improve performance for applications such as Hyper-V. The CSV cache can boost the performance of read requests and is also useful for Scale-Out File Server scenarios.

Enabling the CSV cache reduces the amount of memory available to run VMs on a hyperconverged cluster, so you'll have to balance storage performance with memory available to VHDs.

To set the size of the CSV cache, run the following command. This example sets a 2 GB CSV cache per server:

```powershell
$ClusterName = "ClusterS1"
$CSVCacheSize = 2048 #Size in MB

Write-Output "Setting the CSV cache..."
(Get-Cluster $ClusterName).BlockCacheSize = $CSVCacheSize

$CSVCurrentCacheSize = (Get-Cluster $ClusterName).BlockCacheSize
Write-Output "$ClusterName CSV cache size: $CSVCurrentCacheSize MB"
```

## Step 8: Configure Storage Replica (stretched cluster)

Next, we will configure Storage Replica by creating replication groups (RG) for each site and specifying the data volumes and log volumes for both the source server nodes in Site1 (Server1, Server2) and the destination (replicated) server nodes in Site2 (Server3, Server4).

The `New-SRPartnership` cmdlet creates a replication partnership between the two replication groups for the two sites. In this example `Replication1` is the replication group for primary node Server1 in Site1, and `Replication2` is the replication group for destination node Server3 in Site2.

This cmdlet is also where you specify the source data and log volume names:

```powershell
New-SRPartnership -SourceComputerName "Server1" -SourceRGName "Replication1" -SourceVolumeName "C:\ClusterStorage\Disk1\" -SourceLogVolumeName "G:" -DestinationComputerName "Server3" -DestinationRGName "Replication2" -DestinationVolumeName "H:" -DestinationLogVolumeName "I:"
```

## Step 9: Verify data replication (stretched cluster)

With Storage Replica, there are several events you can view to ascertain the state of replication between sites in stretched clusters.

To use the previous examples, we can determine replication progress on Server1 in Site1 by running the following command and examining events 5015, 5002, 5004, 1237, 5001, and 2200:

```powershell
Get-WinEvent -ComputerName Server1 -ProviderName Microsoft-Windows-StorageReplica -max 20
```

For node Server3 in Site2, run the following command to see Storage Replica events that show creation of the partnership. This event states the number of copied bytes and the time taken to replicate from Server1 to Server3:

```powershell
Get-WinEvent -ComputerName Server3 -ProviderName Microsoft-Windows-StorageReplica | Where-Object {$_.ID -eq "1215"} | fl
```

For node Server3 in Site2, run the following command and examine events 5009, 1237, 5001, 5015, 5005, and 2200 to understand the replication progress. There should be no warnings of errors. However, there will be many "1237" events - these simply indicate progress.

```powershell
Get-WinEvent -ComputerName Server3 -ProviderName Microsoft-Windows-StorageReplica | FL
```

USe this sample for a script that will not terminate:

```powershell
while($true) {
$v = (Get-SRGroup -Name "Replication2").replicas | Select-Object numofbytesremaining
[System.Console]::Write("Number of bytes remaining: {0}`r", $v.numofbytesremaining)
Start-Sleep -s 5
}
```

To get the replication state for the stretched cluster, use `Get-SRGroup` and `Get-SRPartnership`:

```powershell
Get-SRGroup -Cluster ClusterS1
```

```powershell
Get-SRPartnership -Cluster ClusterS1
```

```powershell
(Get-SRGroup).replicas -Cluster ClusterS1
```

Once successful data replication is confirmed between sites, you can create your VMs and other workloads.

## Next steps

- You may want to further validate your cluster. See [Validate server cluster].

- You can create your virtual machines. See [Manage VMs on Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/manage/vm).

- You can also create a cluster using Windows Admin Center. See [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).