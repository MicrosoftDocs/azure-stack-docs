---
title: Tutorial - Deploy a cluster in Azure Kubernetes Service on Azure Stack HCI
description: In this tutorial, learn how to create an AKS on Azure Stack HCI cluster and to use kubectl to connect to the Kubernetes master node.
services: 
ms.topic: tutorial
ms.date: 04/13/2021
ms.author: jeguan
author: jeguan
---

# Tutorial: Deploy a workload cluster on Azure Kubernetes Service on Azure Stack HCI

Kubernetes provides a distributed platform for containerized applications. In this tutorial, part three of seven, an AKS on Azure Stack HCI cluster is deployed in Azure Kubernetes Service on Azure Stack HCI. You learn how to:

> [!div class="checklist"]
> * Deploy an AKS cluster on Azure Stack HCI 
> * Install the Kubernetes CLI (kubectl)
> * Configure kubectl to connect to your workload cluster

In later tutorials, the Azure Vote application is deployed to the cluster, scaled, and updated.

## Before you begin

In previous tutorials, a container image was created and uploaded to an Azure Container Registry instance. If you haven't done these steps, and would like to follow along, start at [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

This tutorial uses the AksHci PowerShell module. If you have not installed it yet, run the following command to install it.

Download the `AKS-HCI-Public-Preview` from the [Azure Kubernetes Service on Azure Stack HCI registration page](https://aka.ms/AKS-HCI-Evaluate). The zip file `AksHci.Powershell.zip` contains the PowerShell module. You will also need to install the following Azure PowerShell modules.

**If you are using remote PowerShell, you must use CredSSP.** 

## Install the Azure Kubernetes Service Host

First, you must configure your registration settings.

```powershell
Set-AksHciRegistration -subscription mysubscription -resourceGroupName myresourcegroup
```

**You must customize these values according to your Azure subscription and resource group name.**

Then, run the following command to ensure that all requirements on each physical node are met to install Azure Kubernetes service on Azure Stack HCI.

```powershell
Initialize-AksHciNode
```

Next, we will create a virtual network. You will need to get the names of your available external switches:

```powershell
Get-VMSwitch
```

**You must use an external switch**

Sample Output:
```output
Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
extSwitch External Mellanox ConnectX-3 Pro Ethernet Adapter
```

In this example, we will use `extSwitch` as the name of the vSwitch.

Run the following command to create a virtual network with static IP.

```powershell
$vnet = New-AksHciNetworkSetting -name myvnet -vSwitchName "extSwitch" -macPoolName myMacPool -k8sNodeIpPoolStart "172.16.10.0" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd
"172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" -vlanId 9
```

Then, configure your deployment with the following command.

```powershell
Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" 
```

Now, you are ready to install the Azure Kubernetes Service on Azure Stack HCI host.

```powershell
Install-AksHCi
```

## Create a Kubernetes cluster

Create a Kubernetes cluster using the command [New-AksHciCluster][new-akshcicluster]. The following example creates a cluster named *mycluster* with the default values. This command will create a workload cluster with 1 Linux node.

```powershell
New-AksHciCluster -name mycluster
```

To verify that deployment was successful, run the following command.

```powershell
Get-AksHcicluster -name mycluster
```

**Output:**
```
Name            : mycluster
Version         : v1.18.14
Control Planes  : 1
Linux Workers   : 1
Windows Workers : 0
Phase           : provisioned
Ready           : True

```

## Install the Kubernetes CLI

To connect to the Kubernetes cluster from your local computer, you use [kubectl][kubectl], the Kubernetes command-line client.


## Connect to cluster using kubectl

To configure `kubectl` to connect to your Kubernetes cluster, use the [Get-AksHciCredential](get-akshcicredential.md) command. The following example gets credentials for the cluster named *mycluster*.

```powershell
Get-AksHciCredential -name mycluster
```

To verify the connection to your cluster, run the [kubectl get nodes][kubectl-get] command to return a list of the cluster nodes:

```
$ kubectl get nodes
```

**Output:**
```
NAME              STATUS   ROLES    AGE     VERSION
moc-l9oyb6kgedw   Ready    master   6m10s   v1.18.14
moc-le9q8mro8mg   Ready    <none>   4m42s   v1.18.14
```

## Next steps

In this tutorial, a Kubernetes cluster was deployed in AKS, and you configured `kubectl` to connect to it. You learned how to:

> [!div class="checklist"]
> * Deploy an AKS cluster on Azure Stack HCI
> * Install the Kubernetes CLI (kubectl)
> * Configure kubectl to connect to your AKS cluster

Advance to the next tutorial to learn how to deploy an application to the cluster.

> [!div class="nextstepaction"]
> [Deploy application in Kubernetes](tutorial-kubernetes-deploy-application.md)

<!-- LINKS - external -->
[kubectl]: https://kubernetes.io/docs/user-guide/kubectl/
[kubectl-get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get

<!-- LINKS - internal -->

