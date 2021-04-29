---
title: Quickstart to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using Windows PowerShell
description: Learn how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using Windows PowerShell.
author: jessicaguan
ms.topic: quickstart
ms.date: 04/13/2021
ms.author: jeguan
---
# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI and deploy a workload cluster using PowerShell

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

In this quickstart, you'll learn how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using PowerShell. To instead use Windows Admin Center, see [Set up with Windows Admin Center](setup.md).

## Before you begin

Make sure you have one of the following:
 - 2-4 node Azure Stack HCI cluster
 - Windows Server 2019 Datacenter failover cluster
 
Before getting started, make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page. 
**We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't have any of the above, follow instructions on the [Azure Stack HCI registration page](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).    

## Install the Azure PowerShell and AksHci PowerShell modules

Download the `AKS-HCI-Public-Preview-April-2021` from the [Azure Kubernetes Service on Azure Stack HCI registration page](https://aka.ms/AKS-HCI-Evaluate). The zip file `AksHci.Powershell.zip` contains the PowerShell module. You will also need to install the following Azure PowerShell modules.

```powershell
Install-Module -Name Az.Accounts -Repository PSGallery -RequiredVersion 2.2.4
Install-Module -Name Az.Resources -Repository PSGallery -RequiredVersion 3.2.0
Install-Module -Name AzureAD -Repository PSGallery -RequiredVersion 2.0.2.128
```

**Close all PowerShell windows.** Delete any existing directories for AksHci, AksHci.Day2, Kva, Moc and MSK8sDownloadAgent located in the path `%systemdrive%\program files\windowspowershell\modules`. Once this is done, you can extract the contents of the new zip file. Make sure to extract the zip file in the correct location (`%systemdrive%\program files\windowspowershell\modules`).

   ```powershell
   Import-Module AksHci
   Import-Module Az.Accounts 
   Import-Module Az.Resources
   Import-Module AzureAD
   ```

**Close all PowerShell windows** and reopen a new administrative session to check if you have the latest version of the PowerShell module.
  
   ```powershell
   Get-Command -Module AksHci
   ```
To view the complete list of AksHci PowerShell commands, see [AksHCI PowerShell](./akshci.md).

## Step 1: Log in to Azure and configure registration settings

Run the following [Set-AksHciRegistration](set-akshciregistration.md) PowerShell command with your subscription and resource group name to log into Azure. You must have an Azure subscription, and an existing Azure resource group in the East US, Southeast Asia, or West Europe Azure regions to proceed.

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

## Step 2: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI.
Open PowerShell as an administrator and run the following [Initialize-AksHciNode](initialize-akshcinode.md) command.

```powershell
Initialize-AksHciNode
```

## Step 3: Create a virtual network

To get the names of your available external switches, run this command:

```powershell
Get-VMSwitch
```

You must use an external switch.

Sample Output:
```output
Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
extSwitch External Mellanox ConnectX-3 Pro Ethernet Adapter
```

To create a virtual network for the nodes in your deployment to use, create an environment variable with the **New-AksHciNetworkSetting** PowerShell command. This will be used later to configure a deployment that uses static IP. If you want to configure your AKS deployment with DHCP, visit [New-AksHciNetworkSetting](.\new-akshcinetworksetting.md) for examples. You can also review some [networking node concepts](./concepts-node-networking.md).

```powershell
#static IP
$vnet = New-AksHciNetworkSetting -name myvnet -vSwitchName "extSwitch" -macPoolName myMacPool -k8sNodeIpPoolStart "172.16.10.0" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd
"172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" -vlanId 9
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 4: Configure your deployment

Set the configuration settings for the Azure Kubernetes Service host using the [Set-AksHciConfig](./set-akshciconfig.md) command. You must specify the `imageDir` and `cloudConfigLocation` parameters. If you want to reset your config details, run the command again with new parameters.

Configure your deployment with the following command.

```powershell
Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

> [!NOTE]
> The value for `-cloudservicecidr` given in this example command will need to be customized for your environment.

## Step 5: Start a new deployment

After you've configured your deployment, you must start it. This will install the Azure Kubernetes Service on Azure Stack HCI agents/services and the Azure Kubernetes Service host.

To begin deployment, run the following command.

```powershell
Install-AksHci
```

### Verify your deployed Azure Kubernetes Service host

To ensure that your Azure Kubernetes Service host was deployed, run the [Get-AksHciCluster](./get-akshcicluster.md) command. You will also be able to get Kubernetes clusters using the same command after deploying them.

```powershell
Get-AksHciCluster
```

**Output:**
```

Name            : clustergroup-management
Version         : v1.18.14
Control Planes  : 1
Linux Workers   : 0
Windows Workers : 0
Phase           : provisioned
Ready           : True
```

## Step 6: Create a Kubernetes cluster

After installing your Azure Kubernetes Service host, you are ready to deploy a Kubernetes cluster.

Open PowerShell as an administrator and run the following [New-AksHciCluster](./new-akshcicluster.md) command.

```powershell
New-AksHciCluster -name mycluster
```

### Check your deployed clusters

To get a list of your deployed Azure Kubernetes Service host and Kubernetes clusters, run the following [Get-AksHciCluster](get-akshcicluster.md) PowerShell command.

```powershell
Get-AksHciCluster
```

## Step 7: Scale a Kubernetes cluster

If you need to scale your cluster up or down, you can change the number of control plane nodes, Linux worker nodes, or Windows worker nodes using the [Set-AksHciCluster](./set-akshcicluster.md) command.

To scale control plane nodes, run the following command.

```powershell
Set-AksHciCluster –name mycluster -controlPlaneNodeCount 3
```

To scale the worker nodes, run the following command.

```powershell
Set-AksHciCluster –name mycluster -linuxNodeCount 3 -windowsNodeCount 1
```

The control plane nodes and the worker nodes must be scaled independently.

## Step 8: Access your clusters using kubectl

To access your Kubernetes clusters using kubectl, run the [Get-AksHciCredential](./get-akshcicredential.md) PowerShell command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl. You can also use kubectl to [deploy applications using Helm](./helm-deploy.md).

```powershell
Get-AksHciCredential -name mycluster
```

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -name mycluster
```

## Get logs

To get logs from your all your pods, run the [Get-AksHciLogs](./get-akshcilogs.md) command. This command will create an output zipped folder called `akshcilogs.zip` in your working directory. The full path to the `akshcilogs.zip` folder will be the output after running the command below.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using PowerShell. You also learned how to use PowerShell to scale a Kubernetes cluster and to access clusters with `kubectl`.

## Next steps

- [Connect your clusters to Azure Arc for Kubernetes](./connect-to-arc.md).
- [Deploy a Linux application on your Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
