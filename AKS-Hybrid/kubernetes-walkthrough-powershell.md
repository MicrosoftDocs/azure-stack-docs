---
title: Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters 
description: Learn how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using Windows PowerShell.
author: sethmanheim
ms.topic: quickstart
ms.date: 01/19/2023
ms.author: sethm 
ms.lastreviewed: 05/02/2022
ms.reviewer: jeguan
ms.custom:
  - mode-api
  - kr2b-contr-experiment
  - devx-track-azurepowershell

# Intent: As an IT Pro, I want to use Windows PowerShell to create an AKS on Azure Stack HCI and Windows Server cluster.
# Keyword: AKS setup PowerShell 
---
# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI and Windows Server and deploy a workload cluster using PowerShell

> Applies to: Azure Stack HCI or Windows Server Datacenter

In this quickstart, you'll learn the setup for an Azure Kubernetes Service (AKS) host. You will create AKS on Azure Stack HCI and Windows Server clusters using PowerShell. To use Windows Admin Center instead, see [Set up with Windows Admin Center](setup.md).

> [!NOTE]
> - If you have pre-staged cluster service objects and DNS records, see [Deploy an AKS host with prestaged cluster service objects and DNS records using PowerShell](prestage-cluster-service-host-create.md).
> - If you have a proxy server, see [Set up an AKS host and deploy a workload cluster using PowerShell and a proxy server](set-proxy-settings.md).
> - Installing AKS on Azure Stack HCI after setting up Arc VMs is not supported. Read [known issues with Arc VMs](/azure-stack/hci/manage/troubleshoot-arc-enabled-vms#limitations-and-known-issues) for more information. If you want to install AKS on Azure Stack HCI, you will have to uninstall Arc Resource Bridge and then install AKS on Azure Stack HCI. You can deploy a new Arc Resource Bridge again after cleanup and installing AKS-HCI, but it won't remember the VM entities created previously. 

## Before you begin

- Make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page.
- Use an Azure account to register your AKS host for billing. For more information, visit [Azure requirements](.\system-requirements.md#azure-requirements).

## Install the AksHci PowerShell module

[!INCLUDE [install the AksHci PowerShell module](./includes/install-akshci-ps.md)]

## Register the resource provider to your subscription

Before the registration process, you need to enable the appropriate resource provider in Azure for AKS on Azure Stack HCI and Windows Server registration. To do that, run the following PowerShell commands.

To log in to Azure, run the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command:

```powershell
Connect-AzAccount
```

If you want to switch to a different subscription, run the [Set-AzContext](/powershell/module/az.accounts/set-azcontext?view=azps-5.9.0&preserve-view=true) PowerShell command:

```powershell
Set-AzContext -Subscription "xxxx-xxxx-xxxx-xxxx"
```

Run the following command to register your Azure subscription to Azure Arc enabled Kubernetes resource providers. This registration process can take up to 10 minutes, but it only needs to be performed once on a specific subscription.
   
```powershell
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Register-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation
```

To validate the registration process, run the following PowerShell command:

```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Get-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation
```

## Step 1: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install AKS on Azure Stack HCI and Windows Server. Open PowerShell as an administrator and run the following [Initialize-AksHciNode](./reference/ps/initialize-akshcinode.md) command.
Run the following command on all nodes in your Azure Stack HCI and Windows Server cluster.

```powershell
Initialize-AksHciNode
```

## Step 2: Create a virtual network

Run the following commands in step 2 on any one node in your Azure Stack HCI and Windows Server cluster.

To get the names of your available switches, run the following command. Make sure the `SwitchType` of your VM switch is "External".

```powershell
Get-VMSwitch
```

Sample Output:

```output
Name        SwitchType     NetAdapterInterfaceDescription
----        ----------     ------------------------------
extSwitch   External       Mellanox ConnectX-3 Pro Ethernet Adapter
```

To create a virtual network for the nodes in your deployment to use, create an environment variable with the **New-AksHciNetworkSetting** PowerShell command. This will be used later to configure a deployment that uses static IP. If you want to configure your AKS deployment with DHCP, visit [New-AksHciNetworkSetting](./reference/ps/new-akshcinetworksetting.md) for examples. You can also review some [networking node concepts](./concepts-node-networking.md).

```powershell
#static IP
$vnet = New-AksHciNetworkSetting -name myvnet -vSwitchName "extSwitch" -k8sNodeIpPoolStart "172.16.10.1" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" -vlanId 9
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 3: Configure your deployment

Run the following commands in step 3 on any one node in your Azure Stack HCI and Windows Server cluster.

To create the configuration settings for the AKS host, use the [Set-AksHciConfig](./reference/ps/set-akshciconfig.md) command. You must specify the `imageDir`, `workingDir`, and `cloudConfigLocation` parameters. If you want to reset your configuration details, run the command again with new parameters.

Configure your deployment with the following command.

```powershell
Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -workingDir c:\ClusterStorage\Volume1\ImageStore -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 4: Log in to Azure and configure registration settings
### Option 1: Using your Azure AD account if you have "Owner" permissions

Run the following [Set-AksHciRegistration](/azure-stack/aks-hci/reference/ps/set-akshciregistration) PowerShell command with your subscription and resource group name to log into Azure. You must have an Azure subscription, and an existing Azure resource group in the Australia East, East US, Southeast Asia, or West Europe Azure regions to proceed.

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

### Option 2: Using an Azure service principal

If you do not have access to a subscription on which you're an "Owner", you can register your AKS host to Azure for billing using a service principal. For more information about how to use a service principal, see [register AKS on Azure Stack HCI and Windows Server using a service principal](reference/ps/set-akshciregistration.md#register-aks-hybrid-using-a-service-principal).

## Step 5: Start a new deployment

Run the following command in step 5 on any one node in your Azure Stack HCI or Windows Server cluster.

After you've configured your deployment, you must start it in order to install the AKS on Azure Stack HCI and Windows Server agents/services and the AKS host. To begin deployment, run the following command.

> [!TIP]
> To see additional status detail during installation, set `$VerbosePreference = "Continue"` before proceeding.

```powershell
Install-AksHci
```
> [!WARNING]
> During installation of your Azure Kuberenetes Service host, a *Kubernetes - Azure Arc* resource type is created in the resource group that's set during registration. Do not delete this resource as it represents your Azure Kuberenetes Service host. You can identify the resource by checking its distribution field for a value of `aks_management`. Deleting this resource will result in an out-of-policy deployment.

## Step 6: Create a Kubernetes cluster

After installing your AKS host, you can deploy a Kubernetes cluster. Open PowerShell as an administrator and run the following [New-AksHciCluster](./reference/ps/new-akshcicluster.md) command. This example command will create a new Kubernetes cluster with one Linux node pool named *linuxnodepool* with a node count of 1. 

To read more information about node pools, visit [Use node pools in AKS on Azure Stack HCI and Windows Server](use-node-pools.md).

```powershell
New-AksHciCluster -name mycluster -nodePoolName linuxnodepool -nodeCount 1 -osType Linux
```

### Check your deployed clusters

To get a list of your deployed Kubernetes clusters, run the following [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) PowerShell command.

```powershell
Get-AksHciCluster
```

**Output**
```
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : linuxnodepool
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

To get a list of the node pools in the cluster, run the following [Get-AksHciNodePool](./reference/ps/get-akshcinodepool.md) PowerShell command.

```powershell
Get-AksHciNodePool -clusterName mycluster
```

```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

## Step 7: Connect your cluster to Arc enabled Kubernetes

Connect your cluster to Arc enabled Kubernetes by running the [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) command. The below example connects your AKS on Azure Stack HCI and Windows Server cluster to Arc using the subscription and resource group details you passed in the `Set-AksHciRegistration` command.

```powershell
Connect-AzAccount
Enable-AksHciArcConnection -name mycluster
```

> [!NOTE]
> If you encounter issues or error messages during the installation process, see [installation known issues and errors](/azure-stack/aks-hci/known-issues-installation) for more information.

## Scale a Kubernetes cluster

If you need to scale your cluster up or down, you can change the number of control plane nodes by using the [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) command. To change the number of Linux or Windows worker nodes in your node pool, use the [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md) command.

To scale control plane nodes, run the following command:

```powershell
Set-AksHciCluster -name mycluster -controlPlaneNodeCount 3
```

To scale the worker nodes in your node pool, run the following command:

```powershell
Set-AksHciNodePool -clusterName mycluster -name linuxnodepool -count 3
```

> [!NOTE]
> In previous versions of AKS on Azure Stack HCI and Windows Server, the [Set-AksHciCluster](/azure-stack/aks-hci/reference/ps/set-akshcicluster) command was also used to scale worker nodes. Now that AKS on Azure Stack HCI and Windows Server is introducing node pools in workload clusters, you can only use this command to scale worker nodes -- **if** your cluster was created with the old parameter set in [New-AksHciCluster](/azure-stack/aks-hci/reference/ps/new-akshcicluster).

To scale worker nodes in a node pool, use the [Set-AksHciNodePool](/azure-stack/aks-hci/reference/ps/set-akshcinodepool) command.

## Access your clusters using kubectl

To access your Kubernetes clusters using kubectl, run the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl. You can also use kubectl to [deploy applications using Helm](./helm-deploy.md).

```powershell
Get-AksHciCredential -name mycluster
```

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -name mycluster
```

> [!NOTE]
> Make sure that your cluster is deleted by looking at the existing VMs in the Hyper-V Manager. If they are not deleted, then you can manually delete the VMs. Then, run the command `Restart-Service wssdagent`. This should be done on each node in the failover cluster.

## Get logs

To get logs from your all your pods, run the [Get-AksHciLogs](./reference/ps/get-akshcilogs.md) command. This command will create an output zipped folder called `akshcilogs.zip` in your working directory. The full path to the `akshcilogs.zip` folder will be the output after running the command below.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to set up an AKS host and create AKS on Azure Stack HCI and Windows Server clusters using PowerShell. You also learned how to use PowerShell to scale a Kubernetes cluster and to access clusters with `kubectl`.

## Next steps

- [Prepare an application](./tutorial-kubernetes-prepare-application.md)
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md)
- [Set up multiple administrators](./set-multiple-administrators.md)
