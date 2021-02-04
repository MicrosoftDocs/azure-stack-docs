---
title: Quickstart to set up an Azure Kubernetes Service host on Azure Stack HCI using Windows PowerShell
description: Learn how to set up an Azure Kubernetes Service host on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 12/02/2020
ms.author: jeguan
---
# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

In this quickstart, you'll learn how to set up an Azure Kubernetes Service host using PowerShell. To instead use Windows Admin Center, see [Set up with Windows Admin Center](setup.md).

## Before you begin

Make sure you have one of the following:
 - 2-4 node Azure Stack HCI cluster
 - Windows Server 2019 Datacenter failover cluster
 - Single node Windows Server 2019 Datacenter 
 
Before getting started, make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page. 
**We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't have any of the above, follow instructions on the [Azure Stack HCI registration page](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).    

   > [!IMPORTANT]
   > When removing Azure Kubernetes Service on Azure Stack HCI, see [Remove Azure Kubernetes Service on Azure Stack HCI](#remove-azure-kubernetes-service-on-azure-stack-hci) and carefully follow the instructions. 

## Step 1: Install the AksHci PowerShell module

   ```powershell
   Install-Module -Name AksHci -RequiredVersion 0.2.15 -Repository PSGallery
   ```

### Step 1.1: Clean install of the AksHci PowerShell module

Run the following command before proceeding.
   ```powershell
   Uninstall-AksHci
   ```

### Step 1.2: Validate upgraded PowerShell module

**Close all PowerShell windows** and reopen a new administrative session to check if you have the latest version of the PowerShell module.  

   ```powershell
   Get-Command -Module AksHci
   ```
 
**Output:**
```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Initialize-AksHciNode                              0.2.15     akshci
Function        Get-AksHciCluster                                  0.2.15     akshci
Function        Get-AksHciClusterUpgrades                          0.2.15     akshci
Function        Get-AksHciConfig                                   0.2.15     akshci
Function        Get-AksHciCredential                               0.2.15     akshci
Function        Get-AksHciEventLog                                 0.2.15     akshci
Function        Get-AksHciKubernetesVersion                        0.2.15     akshci
Function        Get-AksHciLogs                                     0.2.15     akshci
Function        Get-AksHciUpdates                                  0.2.15     akshci
Function        Get-AksHciVersion                                  0.2.15     akshci
Function        Get-AksHciVmSize                                   0.2.15     akshci
Function        Install-AksHci                                     0.2.15     akshci
Function        Install-AksHciAdAuth                               0.2.15     akshci
Function        Install-AksHciArcOnboarding                        0.2.15     akshci
Function        New-AksHciCluster                                  0.2.15     akshci
Function        New-AksHciNetworkSetting                           0.2.15     akshci
Function        Remove-AksHciCluster                               0.2.15     akshci
Function        Restart-AksHci                                     0.2.15     akshci
Function        Set-AksHciClusterNodeCount                         0.2.15     akshci
Function        Set-AksHciConfig                                   0.2.15     akshci
Function        Uninstall-AksHci                                   0.2.15     akshci
Function        Uninstall-AksHciAdAuth                             0.2.15     akshci
Function        Uninstall-AksHciArcOnboarding                      0.2.15     akshci
Function        Update-AksHci                                      0.2.15     akshci
Function        Update-AksHciCluster                               0.2.15     akshci
```

## Step 2: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI.

Open PowerShell as an administrator and run the following command.

   ```powershell
   Initialize-AksHciNode
   ```

When the checks are finished, you'll see "Done" displayed in green text.

## Step 3: Create a virtual network

To create a virtual network for the nodes in your deployment to use, create an environment variable with the [New-AksHciNetworkSetting](.\new-akshcinetworksetting.md) PowerShell command. This will be used later to configure a deployment that uses static IP.

   ```powershell
   $vnet = New-AksHciNetworkSetting -vnetName "External" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipaddressprefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsservers "172.16.0.1"
   ```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

To get the names of your available switches, run this command:

```powershell
Get-VMSwitch
```

## Step 4: Configure your deployment

Set the configuration settings for the Azure Kubernetes Service host using the [Set-AksHciConfig](./set-akshciconfig) command. **If you're deploying on a 2-4 node Azure Stack HCI cluster or a Windows Server 2019 Datacenter failover cluster, you must specify the `imageDir` and `cloudConfigLocation` parameters.** For a single node Windows Server 2019 Datacenter, all parameters are optional and set to their default values. However, for optimal performance, **we recommend using a 2-4 node Azure Stack HCI cluster deployment.**

Configure your deployment with the following command.


   ```powershell
   Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet
   ```

### Reset the Azure Kubernetes Service on Azure Stack HCI configuration

To reset the Azure Kubernetes Service on Azure Stack HCI configuration, run the following command. Running this command on its own will reset the configuration to default values.

```powershell
Set-AksHciConfig
```

## Step 5: Start a new deployment

After you've configured your deployment, you must start deployment. This will install the Azure Kubernetes Service on Azure Stack HCI agents/services and the Azure Kubernetes Service host.

To begin deployment, run the following command.

```powershell
Install-AksHci
```

### Verify your deployed Azure Kubernetes Service host

To ensure that your Azure Kubernetes Service host was deployed, run the [Get-AksHciCluster](./get-akshcicluster) command. You will also be able to get Kubernetes clusters using the same command after deploying them.

```powershell
Get-AksHciCluster
```

**Output:**
```

Name            : clustergroup-management
Version         : v1.18.8
Control Planes  : 1
Linux Workers   : 0
Windows Workers : 0
Phase           : provisioned
Ready           : True
```

## Step 6: Access your clusters using kubectl

To access your Azure Kubernetes Service host using `kubectl`, run the [Get-AksHciCredential](./get-akshcicredential) command. This will use the specified cluster's _kubeconfig_ file as the default _kubeconfig_ file for `kubectl`. You can also use this command to access other Kubernetes clusters after they are deployed.

```powershell
Get-AksHciCredential -name clustergroup-management
```

## Get logs

To get logs from your all your pods, run the [Get-AksHciLogs](./get-akshcilogs) command. This command will create an output zipped folder called `akshcilogs` in the path `c:\%workingdirectory%\%AKS HCI release number%\%filename%` (for example, `c:\AksHci\0.9.6.0\akshcilogs.zip`).

```powershell
Get-AksHciLogs
```

## Update to the latest version of Azure Kubernetes Service on Azure Stack HCI

To update to the latest version of Azure Kubernetes Service on Azure Stack HCI, run the [Update-AksHci](./update-akshci) command. The update command only works if you have installed the Oct release. It will not work for releases older than the October release. This update command updates the Azure Kubernetes Service host and the on-premise Microsoft operated cloud platform. For this preview release, the Kubernetes version and AKS host OS version still remain the same. This command does not upgrade any existing workload clusters. New workload clusters created after updating the AKS host will differ from existing workload clusters in terms of Windows node OS version and Kubernetes version.

   ```powershell
   Update-AksHci
   ```
   
We recommend updating workload clusters immediately after updating the management cluster to prevent running unsupported Windows Server OS versions in your Kubernetes clusters with Windows nodes. To update your workload cluster, visit [update your workload cluster](create-kubernetes-cluster-powershell.md).

## Restart Azure Kubernetes Service on Azure Stack HCI

Restarting Azure Kubernetes Service on Azure Stack HCI will remove all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. It will also uninstall the Azure Kubernetes Service on Azure Stack HCI agents and services from the nodes. It will then go back through the original install process steps until the host is recreated. The Azure Kubernetes Service on Azure Stack HCI configuration that you configured via `Set-AksHciConfig` and the downloaded VHDX images are preserved.

To restart Azure Kubernetes Service on Azure Stack HCI with the same configuration settings, run the following command.

```powershell
Restart-AksHci
```

## Reset configuration settings and reinstall Azure Kubernetes Service on Azure Stack HCI

To reinstall Azure Kubernetes Service on Azure Stack HCI with different configuration settings, run the following command first.

```powershell
Uninstall-AksHci
```

After running the above command, you can change the configuration settings with the following command. The parameters remain the same as described in Step 3. If you run this command with no specified parameters, the parameters will be reset to their default values.

```powershell
Set-AksHciConfig
```

After changing the configuration to your desired settings, run the following command to reinstall Azure Stack Kubernetes on Azure Stack HCI.

```powershell
Install-AksHci
```

## Remove Azure Kubernetes Service on Azure Stack HCI

To remove Azure Kubernetes Service on Azure Stack HCI, run the following command. **If you are using PowerShell to uninstall a Windows Admin Center deployment, you must run the command with the `-Force` flag.**

```powershell
Uninstall-AksHci
```

After running the above command, you can run the `Install-AksHci` command to install the Azure Kubernetes Service host with the same configuration as before. If you want to change the configuration, run `Set-AksHciConfig` with the changes you want to make before running the install command.

If you don't want to retain the old configuration, run the following command.

```powershell
Uninstall-AksHci -Force
```

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes. **If you use the uninstall command and go back to Windows Admin Center, run the above uninstall command with the `-Force` flag. If this is not done, PowerShell and Windows Admin Center will be out of sync.**

## Next steps

- [Create a Kubernetes cluster for your applications](create-kubernetes-cluster-powershell.md)
