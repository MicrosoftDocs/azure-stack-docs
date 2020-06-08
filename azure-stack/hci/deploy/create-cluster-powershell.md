---
title: Create an Azure Stack HCI cluster using Windows PowerShell
description: Learn how to create a hyperconverged cluster for Azure Stack HCI using Windows PowerShell
author: v-dasis
ms.topic: article
ms.prod: 
ms.date: 06/07/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---
# Create an Azure Stack HCI cluster using Windows PowerShell

> Applies to: Azure Stack HCI v20H2, Windows Server 2019

Windows PowerShell can be used to create an Azure Stack HCI cluster. In this article, we will create a failover cluster named Cluster1 that uses Storage Spaces Direct and is comprised of four nodes named Server1, Server2, Server3, and Server4.

You will run PowerShell commands from a remote computer running Windows 10, rather than on a host server in the cluster. This remote computer is called the management computer.

## Using Windows PowerShell

When running PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the cluster you are managing. In addition, you may need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a server node.

You will need the Remote Server Administration Tools (RSAT) cmdlets and PowerShell modules for Hyper-V and Failover Clustering. If they aren't available in your PowerShell session on your management computer, you can add them from the `Failover Cluster` Module for Windows PowerShell Feature using the following command: `Add-WindowsFeature RSAT-Clustering-PowerShell`.

> [!NOTE]
> Starting with Windows 10 October 2018 Update, RSAT is included as a set of "Features on Demand" right from Windows 10. Simply go to **Settings > Apps > Apps & features > Optional features > Add a feature > RSAT: Failover Clustering Tools**, and select **Install**. To see installation progress, click the Back button to view status on the **Manage optional features** page. Once installed, RSAT will persist across Windows 10 version upgrades.

## Step 1: Provision the servers

Make sure that Azure Stack HCI has been installed on every server that will be in the cluster. You will use the Server Core installation option. For more information, see [link to topic].

### Step 1.1: Connect to the servers

To connect to the servers, you must first have network connectivity, be joined to the same domain or a fully trusted domain, and have local administrative permissions to the servers.

Open PowerShell and use either the fully-qualified domain name or the IP address of the server you want to connect to. You'll be prompted for a password after you run the following command:

   ```powershell
   Enter-PSSession -ComputerName Server1 -Credential LocalHost\Administrator
   ```

Here's another example of doing the same thing:

   ```powershell
   $myServer1 = "myServer-1"
   $user = "$myServer1\Administrator"

   Enter-PSSession -ComputerName $myServer1 -Credential $user
   ```

> [!TIP]
> When running PowerShell commands from your management PC, you might get an error like *WinRM cannot process the request.* To fix this, use PowerShell to add each server to the Trusted Hosts list on your management computer. This list supports wildcards, like `Server*` for example.
>
> `Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value Server01 -Force`
>  
> To view your Trusted Hosts list, type `Get-Item WSMAN:\Localhost\Client\TrustedHosts`.  
>
> To empty the list, type `Clear-Item WSMAN:\Localhost\Client\TrustedHost`.  

### Step 1.2: Join the domain and add domain accounts

So far you've configured each server with the local administrator account, `<ComputerName>\Administrator`.

To manage the cluster, you'll need to join the servers to a domain and use an Active Directory Domain Services domain account that is in the Administrators group on every server.

Use the `Enter-PSSession` cmdlet to connect to each server and  run the following cmdlet, substituting your own computer name, domain name, and domain credentials:

```powershell  
Add-Computer -NewName "Server1" -DomainName "contoso.com" -Credential "CONTOSO\User" -Restart -Force  
```

If your administrator account isn't a member of the Domain Admins group, add your administrator account to the local Administrators group on each server - or better yet, add the group you use for administrators. You can use the following command to do so:

```powershell
Net localgroup Administrators <Domain\Account> /add
```

### Step 1.3: Install roles and features

The next step is to install required server roles on every server. Here are the roles to install:

- Failover Clustering
- Hyper-V
- File Server (if you want to use a file Witness or host any file shares)
- Data-Center-Bridging (if you're using RoCEv2 instead of iWARP network adapters)
- RSAT-Clustering-PowerShell
- Hyper-V-PowerShell
- Storage Replica (for stretched clusters only)

Use the following command for each server:

```powershell
Install-WindowsFeature -ComputerName Server1 -Name "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"
```

To run the command on all servers in the cluster as the same time, use the following script, modifying the list of variables at the beginning to fit your environment.

```powershell
# Fill in these variables with your values
$ServerList = "Server1", "Server2", "Server3", "Server4"
$FeatureList = "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"

# This part runs the Install-WindowsFeature cmdlet on all servers in $ServerList, passing the list of features in $FeatureList.
Invoke-Command ($ServerList) {
    Install-WindowsFeature -Name $Using:Featurelist
}
```

## Step 2: Configure the network

Your cluster will use Storage Spaces Direct, which requires high-bandwidth, low-latency networking between servers in the cluster. At least 10 GbE networking is required and remote direct memory access (RDMA) is recommended. You can use either iWARP or RoCE, but iWARP is usually easier to set up.

> [!IMPORTANT]
> Depending on your networking equipment, and especially with RoCE v2, some configuration of the top-of-rack network switch may be required. Correct switch configuration is important to ensure reliability and performance of the cluster.

Azure Stack HCI supports switch-embedded teaming (SET) within the Hyper-V virtual switch. This allows the same physical NIC ports to be used for all network traffic while using RDMA, reducing the number of physical NIC ports required. Switch-embedded teaming is recommended.

### Switched or switchless node interconnects

You can use either switched or switchless node interconnects:

- **Switched:** Network switches must be properly configured to handle the bandwidth and networking type. If using RDMA that implements the RoCE protocol, network device and switch configuration is even more important.
- **Switchless:** Nodes can be interconnected using direct connections, avoiding using a switch. It is required that every node have a direct connection with every other node of the cluster.

For instructions to set up networking for the cluster, see [topic link].

## Step 3: Validate cluster setup

Before you actually create the cluster, you must first validate that your servers are prepared and configured properly for cluster inclusion.

### Step 3.1: Prepare drives

Before you enable Storage Spaces Direct later on, ensure your drives are empty with no old partitions or other data. Run the following script to remove all any old partitions or other data.

> [!WARNING]
> This script will permanently remove any data on any drives other than the operating system boot drive.

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

The output will look like this, where **Count** is the number of drives of each model in each server:

```
Count Name                          PSComputerName
----- ----                          --------------
4     ATA SSDSC2BA800G4n            Server1
10    ATA ST4000NM0033              Server1
4     ATA SSDSC2BA800G4n            Server2
10    ATA ST4000NM0033              Server2
4     ATA SSDSC2BA800G4n            Server3
10    ATA ST4000NM0033              Server3
4     ATA SSDSC2BA800G4n            Server4
10    ATA ST4000NM0033              Server4
```

### Step 3.2: Test cluster setup

In this step, you'll ensure that the server nodes are configured correctly to create a cluster. When cluster validation (`Test-Cluster`) is run before the cluster is created, it runs tests that verify your configuration is suitable to successfully function as a failover cluster. The example below uses the `-Include` parameter, with the specific categories of tests specified. This ensures that the right tests are included in the validation.

Use the following to validate a set of servers for use as a hyperconverged cluster:

```powershell
Test-Cluster -Cluster –Node Server1, Server2, Server3, Server4 –Include "Storage Spaces Direct", "Inventory", "Network", "System Configuration"
```

## Step 4: Create the cluster

Now you are ready to create a cluster with the server nodes that you have validated for cluster creation in the preceding steps.

When creating the cluster, you'll get a warning that states - `"There were issues while creating the clustered role that may prevent it from starting. For more information, view the report file below."` You can safely ignore this warning. It's due to no disks being available for the cluster witness. It is highly recommended that a file share witness or cloud witness is configured after creating the cluster.

> [!NOTE]
> If the servers are using static IP addresses, modify the following command to reflect the static IP address by adding the following parameter and specifying the IP address: `–StaticAddress &lt;X.X.X.X&gt;`.

> ```powershell
> New-Cluster –Name Cluster1 –Node Server1, Server2, Server3, Server4 –NoStorage
> ```

> [!NOTE]
> After the cluster is created, it can take time for the cluster name to be replicated. If resolving the cluster isn't successful, in most cases you can substitute the computer name of a server node in the the cluster instead of the cluster name.

## Step 5: Configure a witness

You should configure a witness for your cluster. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline. Two node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. You can use a file share as a witness, or use an Azure cloud witness. A cloud witness is recommended. **<==Should/does the witness be created before S2D is enabled? S2D doesn't seem to be dependent on Witness being created first.**

### Step 5.1: Configure a cloud witness

Use the following to create a cloud witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -CloudWitness -AccountName <AzureStorageAccountName> -AccessKey <AzureStorageAccountAccessKey>
```

### Step 5.2: Configure a file share witness

Use the following to create a file-share witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -FileShareWitness \\fileserver\fsw
```

## Step 6: Enable Storage Spaces Direct

After creating the cluster and the witness, use the `Enable-ClusterStorageSpacesDirect` cmdlet, which will enable Storage Spaces Direct and do the following automatically:

```powershell
New-CimSession -ComputerName Server1 | Enable-ClusterStorageSpacesDirect -PoolFriendlyName 'S2D on Cluster1'
```

- **Create a pool:** Creates a single storage pool that has a name like "S2D on Cluster1".

- **Configures the Storage Spaces Direct caches:** If there is more than one media (drive) type available for Storage Spaces Direct, it enables the fastest as cache devices (read and write in most cases)

- **Tiers:** Creates two tiers as default tiers. One is called "Capacity" and the other called "Performance". The cmdlet analyzes the devices and configures each tier with the mix of device types and resiliency.

The following command enables Storage Spaces Direct:

```powershell
Enable-ClusterStorageSpacesDirect –CimSession Cluster1
```

> [!NOTE]
You can also use a server node name instead of the cluster name above. Using the node name can be more reliable due to DNS replication delays that may occur with the newly created cluster name.

When finished, which may take several minutes, the cluster will be ready for volumes to be created.

## Step 7: Create volumes

The `New-Volume` cmdlet creates the virtual disk, partitions and formats it, creates the volume with matching name, and adds it to cluster shared volumes (CSV) – all in one easy step.

You can optionally enable the CSV cache to use system memory (RAM) as a write-through block-level cache of read operations that aren't already cached by the Windows cache manager. This can improve performance for applications such as Hyper-V. The CSV cache can boost the performance of read requests and is also useful for Scale-Out File Server scenarios.

Enabling the CSV cache reduces the amount of memory available to run VMs on the cluster, so you'll have to balance storage performance with memory available to VHDs.

To set the size of the CSV cache, run the following command. This example sets a 2 GB CSV cache per server:

```powershell
$ClusterName = "Cluster1"
$CSVCacheSize = 2048 #Size in MB

Write-Output "Setting the CSV cache..."
(Get-Cluster $ClusterName).BlockCacheSize = $CSVCacheSize

$CSVCurrentCacheSize = (Get-Cluster $ClusterName).BlockCacheSize
Write-Output "$ClusterName CSV cache size: $CSVCurrentCacheSize MB"
```

## Step 8: Deploy VMs

You are done creating the cluster. The last step is to provision VMs on the cluster.

VM files should be stored on the server's CSV namespace (example: c:\\ClusterStorage\\Volume1), just like VMs on traditional Windows Server failover clusters.

For more information on creating VMs, see [Manage VMs on Azure Stack HCI using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/manage/vm-powershell).

## Next steps

- After creating your cluster, you can test the performance of it using synthetic workloads prior to bringing up any real workloads. This lets you confirm that the cluster is performing properly. For more info, see [Test Storage Spaces Performance Using Synthetic Workloads in Windows Server](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn894707(v=ws.11)?redirectedfrom=MSDN).
- You can also create a cluster using Windows Admin Center. For more info, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).
