---
title: Deploy a workload cluster on AKS hybrid
description: In this tutorial, learn how to create an Azure Kubernetes Service (AKS) cluster and use kubectl to connect to the Kubernetes master node in AKS hybrid.
services: 
ms.topic: tutorial
ms.date: 10/26/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: sethmanheim

# Intent: As an IT Pro, I want step-by-step instructions on how to create a workload cluster in AKS and use kubect1 so I can connect to the Kubernetes master node.
# Keyword: deploy a workload cluster

---

# Tutorial: Deploy a workload cluster on AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

Kubernetes provides a distributed platform for containerized applications. 

In this tutorial, part three of seven, an Azure Kubernetes Service (AKS) cluster is deployed on AKS hybrid. You'll learn how to:

> [!div class="checklist"]
> * Deploy an AKS cluster on Azure Stack HCI
> * Install the Kubernetes CLI (kubectl)
> * Configure kubectl to connect to your workload cluster

In later tutorials, the Azure Vote application is deployed to the cluster, scaled, and updated.

## Before you begin

In previous tutorials, a container image was created and uploaded to an Azure Container Registry instance. If you haven't done these steps, start at [Tutorial 1 - Create container images](tutorial-kubernetes-prepare-application.md).

This tutorial uses the AksHci PowerShell module.

[!INCLUDE [install the AksHci PowerShell module](./includes/install-akshci-ps.md)]

## Install the Azure Kubernetes Service Host

First, you must configure your registration settings.

```powershell
Set-AksHciRegistration -subscription mysubscription -resourceGroupName myresourcegroup
```
**You must customize these values according to your Azure subscription and resource group name.**

Then, run the following command to ensure that all requirements on each physical node are met to install AKS on Azure Stack HCI.

```powershell
Initialize-AksHciNode
```

Next, we will create a virtual network. You will need to get the names of your available external switches:

```powershell
Get-VMSwitch
```

Sample Output:
```output
Name        SwitchType    NetAdapterInterfaceDescription
----        ----------    ------------------------------
extSwitch   External      Mellanox ConnectX-3 Pro Ethernet Adapter
```

Run the following command to create a virtual network with static IP.

```powershell
$vnet = New-AksHciNetworkSetting -name myvnet -vSwitchName "extSwitch" -macPoolName myMacPool -k8sNodeIpPoolStart "172.16.10.0" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" -vlanId 9
```

Then, configure your deployment with the following command.

```powershell
Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" 
```

Now, you are ready to install the AKS host.

```powershell
Install-AksHCi
```

## Create a Kubernetes cluster

Create a Kubernetes cluster using the command [New-AksHciCluster](./reference/ps/new-akshcicluster.md). The following example creates a cluster named *mycluster* with one Linux node pool called *linuxnodepool*, which has a node count of 1.

```powershell
New-AksHciCluster -name mycluster -nodePoolName linuxnodepool -nodeCount 1
```

To verify that deployment was successful, run the following command.

```powershell
Get-AksHcicluster -name mycluster
```

**Output:**
```
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : linuxnodepool
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster

```

> [!NOTE]
> If you use the new parameter sets in `New-AksHciCluster` to deploy a cluster, and then you run `Get-AksHciCluster` to get the cluster information, the fields `WindowsNodeCount` and `LinuxNodeCount` in the output will return `0`. To get the accurate number of nodes in each node pool, use the command `Get-AksHciNodePool` with the specified cluster name.

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

## Install the Kubernetes CLI

To connect to the Kubernetes cluster from your local computer, you use [kubectl][kubectl], the Kubernetes command-line client.


## Connect to cluster using kubectl

To configure `kubectl` to connect to your Kubernetes cluster, use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) command. The following example gets credentials for the cluster named *mycluster*.

```powershell
Get-AksHciCredential -name mycluster
```

To verify the connection to your cluster, run the [kubectl get nodes][kubectl-get] command to return a list of the cluster nodes:

```
kubectl get nodes
```

**Output:**
```
NAME              STATUS   ROLES                  AGE     VERSION
moc-lbs6got5dqo   Ready    <none>                 6d20h   v1.20.7
moc-lel7tzxdt30   Ready    control-plane,master   6d20h   v1.20.7
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

