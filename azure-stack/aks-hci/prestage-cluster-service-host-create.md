---
title: Deploy an AKS host with prestaged cluster service objects and DNS records using PowerShell
description: Learn how to set up an AKS host if you have prestaged cluster service objects and DNS records.
author: abha
ms.topic: how-to
ms.date: 10/27/2021
ms.author: abha
---

# Deploy an AKS host with prestaged cluster service objects and DNS records using PowerShell 

In this how-to guide, you'll learn how to configure your AKS host deployment using PowerShell if you have prestaged cluster service objects and DNS records.

## Before you begin

- Make sure you have satisfied all the prerequisites in [system requirements](system-requirements.md). 
- Download and install the [Azure PowerShell and AksHci PowerShell modules](./kubernetes-walkthrough-powershell.md#install-the-azure-powershell-and-akshci-powershell-modules).

## Step 1: Prepare your Active Directory and DNS server for deployment

If you cannot enable dynamic DNS updates in your DNS environment to allow AKS on Azure Stack HCI to register the cloud agent generic cluster name in Active Directory and the DNS system for discovery, you need to pre-create the respective records in Active Directory and DNS.

Create a generic cluster service in Active Directory with the name `ca-cloudagent` (or a name of your choice), but do not exceed 32 characters in length. You also need to create an associated DNS record pointing to the FQDN of the generic cluster service with the provided `cloudservicecidr` address. More details on the steps in this process can be found in the [Failover Clustering documentation](/windows-server/failover-clustering/prestage-cluster-adds).

The AKS on Azure Stack HCI deployment will attempt to locate the specified `clusterRoleName` in Active Directory before proceeding with the deployment.

> [!Note] 
> Once AKS on Azure Stack HCI is deployed, this information cannot be changed.

## Step 2: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. Open PowerShell as an administrator and run the following [Initialize-AksHciNode](./reference/ps/initialize-akshcinode.md) command.

```powershell
Initialize-AksHciNode
```

## Step 3: Create a virtual network

To create a virtual network for the nodes in your deployment to use, create an environment variable with the **New-AksHciNetworkSetting** PowerShell command. This will be used later to configure a deployment that uses static IP. If you want to configure your AKS deployment with DHCP, visit [New-AksHciNetworkSetting](./reference/ps/new-akshcinetworksetting.md) for examples. You can also review some [networking node concepts](./concepts-node-networking.md).

```powershell
#static IP
$vnet = New-AksHciNetworkSetting -name mgmt-vnet -vSwitchName "extSwitch" -k8sNodeIpPoolStart "172.16.10.1" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" 
```

> [!NOTE]
> You need to customize the values given in this example command for your environment.

## Step 4: Configure your deployment with the prestaged cluster service objects and DNS records

Set the configuration settings for the Azure Kubernetes Service host using the [Set-AksHciConfig](./reference/ps/set-akshciconfig.md) command. You must specify the `workingDir`, `cloudServiceCidr`, `cloudConfigLocation`, and `clusterRoleName` parameters. If you want to reset your configuration details, run the command again with new parameters.

Configure your deployment with the following command:

```powershell
Set-AksHciConfig -workingDir c:\ClusterStorage\Volume1\workingDir -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" -clusterRoleName "ca-cloudagent"
```

> [!NOTE]
> You need to customize the values given in this example command for your environment.

## Step 5: Log in to Azure and configure registration settings

Run the following [Set-AksHciRegistration](./reference/ps/set-akshciregistration.md) PowerShell command with your subscription and resource group name to log into Azure. You must have an Azure subscription, and an existing Azure resource group in the East US, Southeast Asia, or West Europe Azure regions to proceed.

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

## Step 5: Start a new deployment

After you've configured your deployment, you must start it. Starting the deployment installs the Azure Kubernetes Service on Azure Stack HCI agents/services and the Azure Kubernetes Service host. To begin the deployment, run the following command:

```powershell
Install-AksHci
```

> [!WARNING]
> During installation of your Azure Kubernetes Service host, a *Kubernetes - Azure Arc* resource type is created in the resource group that's set during registration. Do not delete this resource as it represents your Azure Kubernetes Service host. You can identify the resource by checking its distribution field for a value of `aks_management`. Deleting this resource will result in an out-of-policy deployment.

In this how-to guide, you learned how to set up an Azure Kubernetes Service host using PowerShell if you have prestaged cluster service objects and DNS records. 

## Next steps
- [Create an AKS workload cluster](./reference/ps/new-akshcicluster.md)
- [Prepare an application](./tutorial-kubernetes-prepare-application.md)
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md)
