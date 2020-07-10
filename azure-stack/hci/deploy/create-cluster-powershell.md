---
title: Create an Azure Stack HCI cluster using Windows PowerShell
description: Learn how to create a hyperconverged cluster for Azure Stack HCI using Windows PowerShell
author: v-dasis
ms.topic: article
ms.prod: 
ms.date: 07/10/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---
# Create an Azure Stack HCI cluster using Windows PowerShell

> Applies to: Azure Stack HCI, version v20H2

In this article you will learn how to use Windows PowerShell to create an Azure Stack HCI hyperconverged cluster that uses Storage Spaces Direct.

You have a choice between two cluster types:

- Standard cluster with at least two server nodes, all residing in a single site.
- Stretched cluster with at least four server nodes that span across two sites, with two nodes per site.

In addition, there are two types of stretched clusters, active/passive and active/active. You can set up active-passive site replication, where there is a preferred site and direction for replication. Active-active replication is where replication can happen bi-directionally from either site. This article covers the active/passive configuration only.

In simple terms, an *active* site is one that has resources and is providing roles and workloads for clients to connect to. A *passive* site is one that does not provide any roles or workloads for clients and is waiting for a failover from the active site for disaster recovery.

Sites can be in two different states, different cities, different floors, or different rooms. Stretched clusters Using two sites provides disaster recovery and business continuity should a site suffer an outage or failure.

In this article, we will create an example cluster named Cluster1 that is comprised of four server nodes named Server1, Server2, Server3, and Server4.

For the stretched cluster scenario, we will use ClusterS1 as the name and use the same four server nodes stretched across sites Site1 and Site2.

## Before you begin

Before you begin, make sure you:

- Have read the hardware and other requirements in [Before you start].
- Validate the OEM hardware for each server in the cluster. See [Validate hardware].
- Install the Azure Stack HCI OS on each server in the cluster. See [Deploy Azure Stack HCI].
- Run PowerShell on a remote (management) computer. See [Install Windows Admin Center]. Don't run PowerShell from a server in the cluster.
- Have administrative privileges. Use an account that’s a member of the local Administrators group on each server.
- Have rights in Active Directory to create objects.

## Using Windows PowerShell

When running PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the server or cluster you are managing. In addition, you may need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

You will also need the Remote Server Administration Tools (RSAT) cmdlets and PowerShell modules for Hyper-V and Failover Clustering. If these aren't already available in your PowerShell session on your management computer, you can add them using the following command: `Add-WindowsFeature RSAT-Clustering-PowerShell`.

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

## Step 2: Configure networking

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

### Configure IP addresses and VLANs

You can configure either one or two subnets. Two subnets are preferred if you want to prevent overloading of the switch interconnect. For example, SMB storage traffic will stay on a subnet that's dedicated to one physical switch.

### Obtain network interface information

Before you can set IP addresses for the network interface cards, there is some information you need first, such as Interface Index (`ifIndex`), `Interface Alias`, and `Address Family`. Write these down for each server node as you will need them later.

Run the following:

```powershell
$ServerList = "Server1", "Server2", "Server3", "Server4"
Get-NetIPInterface -ComputerName $ServerList
```

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

### Configure RDMA

Next, we will enable RDMA on the host vNIC adapters and associate each of these vNICs to a physical network adapter that is associated with the virtual switch.

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$vSwitchName="vSwitch"

#Enable RDMA on the host vNIC adapters
Enable-NetAdapterRDMA "vEthernet (SMB01)","vEthernet (SMB02)" -CimSession $Servers

#Associate each of the vNICs configured for RDMA to a physical adapter that is up and is not virtual to be sure that each RDMA enabled ManagementOS vNIC is mapped to separate RDMA pNIC
Invoke-Command -ComputerName $servers -ScriptBlock {
    $physicaladapters=(get-vmswitch $using:vSwitchName).NetAdapterInterfaceDescriptions | Sort-Object
    $netadapters=foreach ($physicaladapter in $physicaladapters){Get-NetAdapter -InterfaceDescription $physicaladapter}
    $i=1
    foreach ($netadapter in ($Netadapters | Sort-Object -Property MacAddress)){
        Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName "SMB0$i" -ManagementOS -PhysicalNetAdapterName $netadapter.Name
        $i++
    }
}
```

Now we validate that this happened successfully:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
#verify RDMA
Get-NetAdapterRdma -CimSession $Servers | Sort-Object -Property SystemName | Format-Table SystemName,InterfaceDescription,Name,Enabled -AutoSize -GroupBy SystemName
#verify mapping
Get-VMNetworkAdapterTeamMapping -CimSession $Servers -ManagementOS | Format-Table ComputerName,NetAdapterName,ParentAdapter
```

### Configure Jumbo frames

You may need to increase the jumbo frames if you are using iWARP. If not using the default values, make sure all switches are configured end-to-end.

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$JumboSize=9014
Set-NetAdapterAdvancedProperty -CimSession $Servers  -DisplayName "Jumbo Packet" -RegistryValue $JumboSize
```
And validate:

```powershell
$Servers="S2D1","S2D2","S2D3","S2D4"
Get-NetAdapterAdvancedProperty -CimSession $servers -DisplayName "Jumbo Packet"
```

### Configure DCB

Datacenter-Bridging (DCB) is required for RoCE RDMA and recommended in some scenarios for iWARP as well to prioritize traffic or to send pause frames.

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
$vSwitchName="vSwitch"
#install dcb feature
foreach ($server in $servers) {Install-WindowsFeature -Name "Data-Center-Bridging" -ComputerName $server}

#add qos Policies
New-NetQosPolicy "SMB"       -NetDirectPortMatchCondition 445 -PriorityValue8021Action 3 -CimSession $servers
New-NetQosPolicy "ClusterHB" -Cluster                         -PriorityValue8021Action 7 -CimSession $servers
New-NetQosPolicy "Default"   -Default                         -PriorityValue8021Action 0 -CimSession $servers

Invoke-Command -ComputerName $servers -ScriptBlock {
    #Turn on Flow Control for SMB
    Enable-NetQosFlowControl -Priority 3
    #Disable flow control for other traffic than 3 (pause frames should go only from priority 3
    Disable-NetQosFlowControl -Priority 0,1,2,4,5,6,7
    #Disable Data Center bridging exchange (disable accept data center bridging (DCB) configurations from a remote device via the DCBX protocol, which is specified in the IEEE data center bridging (DCB) standard.)
    Set-NetQosDcbxSetting -willing $false -confirm:$false
    #Configure IeeePriorityTag
    #IeePriorityTag needs to be On if you want tag your nonRDMA traffic for QoS. Can be off if traffic uses adapters that pass vSwitch (both SR-IOV and RDMA bypasses vSwitch)
    Set-VMNetworkAdapter -ManagementOS -Name "SMB*" -IeeePriorityTag on
    #Apply policy to the target adapters.  The target adapters are adapters connected to vSwitch
    Enable-NetAdapterQos -InterfaceDescription (Get-VMSwitch -Name $using:vSwitchName).NetAdapterInterfaceDescriptions
    #Create a Traffic class and give SMB Direct 60% of the bandwidth minimum. The name of the class will be "SMB".
    #This value needs to match physical switch configuration. Value might vary based on your needs.
    #If connected directly (in 2 node configuration) skip this step.
    New-NetQosTrafficClass "SMB"       -Priority 3 -BandwidthPercentage 60 -Algorithm ETS
    New-NetQosTrafficClass "ClusterHB" -Priority 7 -BandwidthPercentage 1 -Algorithm ETS
}
```
And validate:

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
#validate QOS Policies
Get-NetQosPolicy -CimSession $servers | Select-Object Name,NetworkProfile,Template,NetDirectPort,PriorityValue8021Action,PSComputerName | Sort-Object PSComputerName | Format-Table -GroupBy PSComputerName

#validate Flow Control (enabled for Priority3, disabled for other priorities)
Invoke-Command -ComputerName $servers -ScriptBlock {get-netqosflowcontrol} | Select-Object Name,Enabled,PSComputerName

#validate Data Center bridging exchange
Invoke-Command -ComputerName $servers -ScriptBlock {Get-NetQosDcbxSetting} | Select-Object Willing,PSComputerName

#validate IEEEPriorityTag
Get-VMNetworkAdapter -CimSession $servers -ManagementOS -Name SMB* | Select-Object Name,IeeePriorityTag,ComputerName

#validate policy on physical adapters
Invoke-Command -ComputerName $servers -ScriptBlock {Get-NetAdapterQos -InterfaceDescription (Get-VMSwitch -Name $using:vSwitchName).NetAdapterInterfaceDescriptions}

#validate traffic classes
Invoke-Command -ComputerName $servers -ScriptBlock {Get-NetQosTrafficClass} | Select-Object Priority,BandwidthPercentage,Algorithm,PSComputerName
```

### Configure iWARP firewall rule

For iWarp RDMA to work, a Windows firewall rule needs to be enabled.

```powershell
$Servers = "Server1", "Server2", "Server3", "Server4"
Enable-NetFirewallRule -Name "FPSSMBD-iWARP-In-TCP" -CimSession $servers
```

```powershell
$Servers="S2D1","S2D2","S2D3","S2D4"
Get-NetFirewallRule -Name "FPSSMBD-iWARP-In-TCP" -CimSession $servers | Select-Object Name,Enabled,Profile,PSComputerName
```

## Step 3: Verify cluster setup

Next, you must first verify that your servers are prepared and configured properly for cluster creating.

As a sanity check first, consider running the following commands:

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

### Step 3.2: Test cluster configuration

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

This task only applies if you are creating a stretched cluster between two sites.

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

Using the `Get-ClusterFaultDomain` cmdlet, verify the nodes are in the correct sites.

```powershell
Get-ClusterFaultDomain -CimSession ClusterS1
```

## Step 6: Enable Storage Spaces Direct

After creating the cluster, use the `Enable-ClusterStorageSpacesDirect` cmdlet, which will enable Storage Spaces Direct and do the following automatically:

- **Create a storage pool:** Creates a storage pool for the cluster that has a name like "Cluster1 Storage Pool".

- **Create a Cluster Performance History disk:** Creates a Cluster Performance History virtual disk in the storage pool.

- **Create data and log volumes:** Creates a data volume and a log volume in the storage pool.

- **Configure Storage Spaces Direct caches:** If there is more than one media (drive) type available for Storage Spaces Direct, it enables the fastest as cache devices (read and write in most cases).

- **Create tiers:** Creates two tiers as default tiers. One is called "Capacity" and the other called "Performance". The cmdlet analyzes the devices and configures each tier with the mix of device types and resiliency.

For stretched clusters, the `Enable-ClusterStorageSpacesDirect` cmdlet will also do the following:

- Check to see if sites have been setup
- Determine which nodes are in which sites
- Determines what storage each node has available
- Checks to see if the Storage Replica feature is installed on each node
- Creates a storage pool for each site and identifies it with the same of the site
- Creates data and log volumes in each storage pool - one per site

The following command enables Storage Spaces Direct. You can also specify a friendly name for a storage pool, as shown here:

```powershell
New-CimSession -Cluster Cluster1 | Enable-ClusterStorageSpacesDirect -PoolFriendlyName 'Cluster1 Storage Pool'
```

To see the storage pools, use this:

```powershell
Get-StoragePool -Cluster Cluster1
```

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

Volume creation is different for single-site standard clusters versus stretched (two-site) clusters. For both scenarios however, you use the `New-Volume` cmdlet to create a virtual disk, partition and format it, create a volume with matching name, and add it to cluster shared volumes (CSV).

For more information, see [Create volumes] (https://docs.microsoft.com/azure-stack/hci/manage/create-volumes).

### Create volumes for single-site clusters

If you have a standard single-site cluster, see [Create volumes] (https://docs.microsoft.com/azure-stack/hci/manage/create-volumes).

### Create volumes for stretched clusters

Creating volumes and virtual disks for stretched clusters is a bit more involved than for single-site clusters. Stretched clusters require a minimum of four volumes - two data volumes and two log volumes, with a data/log volume pair residing in each site. Then you will create a replication group for each site, and setup replication between them.

There are two types of stretched clusters, active/passive and active/active.
You can set up active-passive site replication, where there is a preferred site and direction for replication. Active-active replication is where replication can happen bi-directionally from either site. This article covers the active/passive configuration only.

You can also define a global preferred site where all resources and groups run on that site. There is a `PreferredSite` parameter used for just this purpose. This setting can be defined at the site and group level.  

```powershell
(Get-Cluster).PreferredSite = Site1
```

### Active/passive stretched cluster

The following diagram shows Site 1 as the active site with replication to Site 2, a unidirectional replication.

:::image type="content" source="media/cluster/stretch-active-passive.png" alt-text="Active/passive stretched cluster scenario":::

### Active/active stretched cluster

The following diagram shows both Site 1 and Site 2 as being active sites, with bidirectional replication to the other site.

:::image type="content" source="media/cluster/stretch-active-active.png" alt-text="Active/active stretched cluster scenario":::

OK, now we are ready to begin. We first need to move resource groups around from node to node. The `Move-ClusterGroup` cmdlet is used to this.

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

## Step 8: Configure Storage Replica (stretched cluster)

When using PowerShell to set up Storage Replica for a stretched cluster, the disk that will be used for the source data will need to be added as a Cluster Shared Volume (CSV). All other disks must remain as non-CSV drives in the Available Storage group. These disks will then be added as Cluster Shared Volumes during the Storage Replica creation process.

In the previous step, the virtual disks were added using drive letters to make the identification of them easier. Storage Replica is a one-to-one replication, meaning a single disk can replicate to another single disk.

### Step 8.1: Validate the topology for replication

Before starting, you should run the `Test-SRTopology` cmdlet for an extended period (like several hours). The `Test-SRTopology` cmdlet validates a potential replication partnership and validates the local host to the destination server or remotely between source and destination servers.

This cmdlet will perform will validate that:

- SMB can be accessed over the network, which means that TCP port 445 and port 5445 are open bi-directionally.
- WS-MAN can be accessed over HTTP on the network, which means that TCP port 5985 and 5986 are open.
- An SR WMIv2 provider can be accessed and accepts requests.
- Source and destination data volumes exist and are writable.
- Source and destination log volumes exist with NTFS formatting or ReFS formatting and sufficient free space.
- Storage is initialized in GPT format, not MBR, with matching sector sizes.
- There is sufficient physical memory to run replication.

In addition, the `Test-SRTopology` cmdlet will also measure:

- Round-trip latency of ICMP and report the average.
- Performance counters for write Input/Output and report the average seen on that volume.
- Estimated initial synchronization time.

Once Test-SRTopology completes, it will create an .html file (TestSrTopologyReport with date and time) in your Windows Temp folder. Any warning or failures should be reviewed as they could cause Storage Replica to not be properly created.

An example command that would run for 5 hours would be:

```powershell
Test-SRTopology -SourceComputerName Server1 -SourceVolumeName W: -SourceLogVolumeName X: -DestinationComputerName Server3 -DestinationVolumeName Y: -DestinationLogVolumeName Z: -DurationInMinutes 300 -ResultPath c:\temp
```

### Step 8.2: Create the replication partnership

Now that you completed the `Test-SRTopology` tests, you are ready to configure Storage Replica and create the replication partnership. In a nutshell, we will configure Storage Replica by creating replication groups (RG) for each site and specifying the data volumes and log volumes for both the source server nodes in Site1 (Server1, Server2) and the destination (replicated) server nodes in Site2 (Server3, Server4).

Let's begin:

1. Add the Site1 data disk as a Cluster Shared Volume (CSV):

```powershell
Add-ClusterSharedVolume -Name "Cluster Virtual Disk (Site1)"
```

1. The Available Storage group should be "owned" by the node it is currently sitting on. The group can be moved to Server1 using:

```powershell
Move-ClusterGroup -Name “Available Storage” -Node Server1
```

1. To create the replication partnership, use the `New-SRPartnership` cmdlet. This cmdlet is also where you specify the source data volume and log volume names:

```powershell
New-SRPartnership -SourceComputerName "Server1" -SourceRGName "Replication1" -SourceVolumeName "C:\ClusterStorage\Disk1\" -SourceLogVolumeName "G:" -DestinationComputerName "Server3" -DestinationRGName "Replication2" -DestinationVolumeName "H:" -DestinationLogVolumeName "I:"
```

The `New-SRPartnership` cmdlet creates a replication partnership between the two replication groups for the two sites. In this example `Replication1` is the replication group for primary node Server1 in Site1, and `Replication2` is the replication group for destination node Server3 in Site2.

Storage Replica will now be setting everything up. If there is any data to be replicated, it will do it here. Depending on the amount of data it needs to replicate, this may take a while. It is recommended to not move any groups around until this process completes.

## Step 9: Verify replication (stretched cluster)

With Storage Replica, there are several events you can view to get the state of replication and view Storage Replica events in stretched clusters.

To determine the replication progress for Server1 in Site1, run the Get-WinEvent command and examine events 5015, 5002, 5004, 1237, 5001, and 2200:

```powershell
Get-WinEvent -ComputerName Server1 -ProviderName Microsoft-Windows-StorageReplica -max 20
```

For Server3 in Site2, run the following `Get-WinEvent` command to see the Storage Replica events that show creation of the partnership. This event states the number of copied bytes and the time taken. For example:

```powershell
Get-WinEvent -ComputerName Server3 -ProviderName Microsoft-Windows-StorageReplica | Where-Object {$_.ID -eq "1215"} | FL
```

For Server3 in Site2, run the `Get-WinEvent` command and examine events 5009, 1237, 5001, 5015, 5005, and 2200 to understand the processing progress. There should be no warnings of errors in this sequence. There will be many 1237 events - these indicate progress.

```powershell
Get-WinEvent -ComputerName Server3 -ProviderName Microsoft-Windows-StorageReplica | FL
```

Alternately, the destination server group for the replica states the number of byte remaining to copy at all times, and can be queried through PowerShell with `Get-SRGroup`. For example:

```powershell
(Get-SRGroup).Replicas | Select-Object numofbytesremaining
```

For node Server3 in Site2, run the following command and examine events 5009, 1237, 5001, 5015, 5005, and 2200 to understand the replication progress. There should be no warnings of errors. However, there will be many "1237" events - these simply indicate progress.

```powershell
Get-WinEvent -ComputerName Server3 -ProviderName Microsoft-Windows-StorageReplica | FL
```

As a progress script that will not terminate:

```powershell
while($true) {
$v = (Get-SRGroup -Name "Replication2").replicas | Select-Object numofbytesremaining
[System.Console]::Write("Number of bytes remaining: {0}`r", $v.numofbytesremaining)
Start-Sleep -s 5
}
```

To get replication state within the stretched cluster, use `Get-SRGroup` and `Get-SRPartnership`:

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

- It is important to validate the cluster afterwards. See [Validate server cluster].
- Register your cluster with Azure. See [Register Azure Stack Hub with Azure](https://docs.microsoft.com/azure-stack/operator/azure-stack-registration?view=azs-2002&pivots=state-connected).
- Setup a witness (highly recommended). See [Setup a witness].
- Create volumes and virtual disks. See [Create volumes].
- Provision your VMs. See [Manage VMs on Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/manage/vm).
- You can also create a cluster using Windows Admin Center. See [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).