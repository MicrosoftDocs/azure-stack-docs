---
title: Use the Azure Managed Lustre CSI driver with Azure Kubernetes Service
description: How to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
ms.date: 08/21/2023
author: pauljewellmsft
ms.author: pauljewell
ms.lastreviewed: 02/24/2023
ms.reviewer: brianl

# Intent: As an IT Pro, I want to be able to use a Lustre file system with the apps I've deployed on Kubernetes.
# Keyword: 

---

# Use the Azure Managed Lustre CSI Driver with Azure Kubernetes Service

This article describes how to plan, install, and use [Azure Managed Lustre](/azure/azure-managed-lustre) in [Azure Kubernetes Service (AKS)](/azure/aks/) with the [Azure Managed Lustre Kubernetes container support interface driver (Azure Managed Lustre CSI driver)](https://github.com/kubernetes-sigs/azurelustre-csi-driver).

## About the Azure Managed Lustre CSI driver for AKS

The Azure Managed Lustre Container Support Interface (CSI) driver for AKS enables you to access Azure Managed Lustre storage as persistent storage volumes from Kubernetes containers deployed in [Azure Kubernetes Service (AKS)](/azure/aks/).

## Compatible Kubernetes versions

The Azure Managed Lustre CSI driver for AKS is compatible with [Azure Kubernetes Service (AKS)](/azure/aks/). Other Kubernetes installations are not currently supported.

AKS Kubernetes versions 1.21 and later are supported. This includes all versions currently available when creating a new AKS cluster.

> [!IMPORTANT]
> The Azure Managed Lustre CSI driver currently only works with the Ubuntu Linux OS SKU for node pools of AKS.

## Compatible Lustre versions

The Azure Managed Lustre CSI driver for AKS is compatible with [Azure Managed Lustre](/azure/azure-managed-lustre). Other Lustre installations are not currently supported.  

The Azure Managed Lustre CSI driver versions 0.1.10 and later are supported with the current version of the Azure Managed Lustre service.

<!---
See [Upgrading Azure Managed Lustre CSI driver](/azure/azure-managed-lustre/csi-driver-upgrading) for more info on upgrading the CSI driver.
--->

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/).
- A terminal environment with the Azure CLI tools installed. See [Get started with Azure CLI](/cli/azure/get-started-with-azure-cli)
- [kubectl](https://kubernetes.io/docs/reference/kubectl), the Kubernetes management tool, is installed in your terminal environment. See [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster using Azure CLI](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster)
- Create an Azure Managed Lustre deployment. See [Azure Managed Lustre File System documentation](/azure/azure-managed-lustre)

## Plan your AKS Deployment

There are several options when deploying Azure Kubernetes Service that affect the operation between AKS and Azure Managed Lustre.

### Determine the network type to use with AKS

There are two network types that are compatible with the Ubuntu Linux OS SKU, kubenet and the Azure Container Network Interface (CNI) driver. Both options work with the Azure Managed Lustre CSI driver for AKS but they have different requirements that need to be understood when setting up virtual networking and AKS. See [Networking concepts for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-network) for more information on determining the proper selection.

## Determine network architecture for interconnectivity of AKS and Azure Managed Lustre

Azure Managed Lustre operates within a private virtual network, your Kubernetes must have network connectivity to the Azure Managed Lustre virtual network. There are two common ways to configure the networking between Azure Managed Lustre and AKS.

- Install AKS into it's own Virtual Network and create a virtual network peering with the Azure Managed Lustre Virtual Network.
- Use *Bring your Own Networking* option in AKS to install AKS on a new subnet on the Azure Managed Lustre Virtual Network.

> [!NOTE]
> Installing AKS onto the same subnet as Azure Managed Lustre is not recommended.

### Peering AKS and Azure Managed Lustre virtual networks

The option to peer two different virtual networks has the advantage of separating the management of the various networks to different privileged roles. Peering can also provide additional flexibility as it can be made across Azure subscriptions or regions. Virtual Network Peering will require coordination between the two networks to avoid choosing conflicting IP network spaces.

![Diagram showing two VNets, one for Azure Managed Lustre and one for AKS, with a VNet peering arrow connecting them.](media/use-csi-driver-kubernetes/subnet-access-option-2.png)

### Installing AKS into a subnet on the Azure Managed Lustre virtual network

The option to install the AKS cluster into the Azure Managed Lustre virtual network with the *Bring Your Own Network* feature in AKS can be advantageous where you want scenarios where the network is managed singularly. An additional subnet sized to meet your AKS networking requirements will need to be created in the Azure Managed Lustre virtual network.

There is no privilege separation for network management when provisioning AKS onto the Azure Managed Lustre Network and the AKS service principal will need privileges on the Azure Managed Lustre virtual network.

![Diagram showing Azure Managed Lustre VNet with two subnets, one for the Lustre file system and one for AKS.](media/use-csi-driver-kubernetes/subnet-access-option-1.png)

## Setup overview

To enable the Azure Managed Lustre CSI Driver for Kubernetes, perform these steps:

1. [Create an Azure Managed Lustre file system](#create-an-azure-managed-lustre-file-system)

1. [Create an AKS Kubernetes Cluster](#create-an-aks-cluster)

1. [Create virtual network peering](#create-virtual-network-peering)

1. [Install the Azure Managed Lustre CSI Driver for Kubernetes](#install-the-csi-driver).

1. [Create and configure a persistent volume](#create-and-configure-a-persistent-volume).

1. [Check the installation](#check-the-installation) by optionally using an echo pod to confirm the driver is working.

The following sections describe each task in greater detail.

## Create an Azure Managed Lustre file system

If you haven't already created your Azure Managed Lustre file system cluster, create the cluster now. For instructions, see [Create an Azure Managed Lustre file system in the Azure portal](create-file-system-portal.md). Currently, the driver can only be used with a existing Azure Managed Lustre file system.

## Create an AKS Cluster

If you haven't already created your AKS cluster, create a cluster deployment. See [Deploy an Azure Kubernetes Service (AKS) cluster](/azure/aks/learn/quick-kubernetes-deploy-portal).

## Create virtual network peering

> [!NOTE]
> Skip this network peering step if you installed AKS into a subnet on the Azure Managed Lustre virtual network.

The AKS virtual network is created in a separate resource group from the AKS cluster's resource group. You can find the name of this resource group by going to your AKS cluster in the Azure Portal choosing the **Properties** blade and finding the **Infrastructure** resource group.  This resource group contains the virtual network that needs to be paired with the Azure Managed Lustre virtual network. It matches the pattern **MC\_\<aks-rg-name\>\_\<aks-cluster-name\>\_\<region\>**.

Consult [Virtual Network Peering](/azure/virtual-network/virtual-network-peering-overview) to peer the AKS virtual network with your Azure Manages Lustre virtual network.

> [!TIP]
> Due to the naming of the MC_ resource groups and virtual networks, names of networks can be similar or the same across multiple AKS deployments. When setting up peering pay close attention that you are choosing the AKS networks that you intend to choose.

## Connect to the AKS cluster

Connect to the Azure Kubernetes Service cluster by doing these steps:

1. Open a terminal session with access to the Azure CLI tools and log in to your Azure account.

   ```azurecli
   az login
   ```

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Find your AKS cluster. Select the **Overview** blade, then select the **Connect** button and copy the command for **Download cluster credentials**.

1. In your terminal session paste in the command to download the credentials. It will be a command similar to:

   ```azurecli
   az aks get-credentials --subscription <AKS_subscription_id> --resource_group <AKS_resource_group_name> --name <name_of_AKS>
   ```

1. Install kubectl if it's not present in your environment.

   ```azurecli
   az aks install-cli
   ```

1. Verify that the current context is the AKS cluster you just installed the credentials and that you can connect to it:

   ```bash
   kubectl config current-context
   kubectl get deployments --all-namespaces=true
   ```

## Install the CSI driver

To install the CSI driver, run the following command:

```bash
curl -skSL https://raw.githubusercontent.com/kubernetes-sigs/azurelustre-csi-driver/main/deploy/install-driver.sh | bash
```

For local installation command samples, see [Install Azure Lustre CSI Driver on a Kubernetes cluster](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/install-csi-driver.md).

## Create and configure a persistent volume

To create a persistent volume for an existing Azure Managed Lustre file system, do these steps:

1. Copy the following configuration files from the **/docs/examples/** folder in the [azurelustre-csi-driver](https://github.com/kubernetes-sigs/azurelustre-csi-driver/tree/main/docs/examples) repository. If you cloned the repository when you [installed the CSI driver](#install-the-csi-driver), you have local copies available already.

   - storageclass_existing_lustre.yaml
   - pvc_storageclass.yaml

   If you don't want to clone the entire repository, you can download each file individually. Open each of the following links, copy the file's contents, and then paste the contents into a local file with the same filename.

   - [storageclass_existing_lustre.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/storageclass_existing_lustre.yaml)
   - [pvc_storageclass.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/pvc_storageclass.yaml)

1. In the **storageclass_existing_lustre.yaml** file, update the internal name of the Lustre cluster and the MSG IP address.

   ![Screenshot of storageclass_existing_lustre.yaml file with values to replace highlighted.](media/use-csi-driver-kubernetes/storageclass-values-highlighted.png)

   Both settings are displayed in the Azure portal, on the **Client connection** page for your Azure Lustre file system.

   ![Screenshot of the Azure portal Client Connection page. The MGS IP address and the "lustrefs" name in the mount command are highlighted.](media/use-csi-driver-kubernetes/portal-mount-values-highlighted.png)

   Make these updates:

   - Replace `EXISTING_LUSTRE_FS_NAME` with the system-assigned internal name of the Lustre cluster in your Azure Managed Lustre file system. The internal name is usually `lustrefs`. The internal name isn't the name that you gave the file system when you created it.

     The suggested `mount` command includes the name highlighted in the following address string.

     ![Screenshot of a sample address string on the Client Connection page. The internal name of the Lustre cluster is highlighted.](media/use-csi-driver-kubernetes/portal-mount-address-string.png)

   - Replace `EXISTING_LUSTRE_IP_ADDRESS` with the **MSG IP Address**.

1. To create the storage class and the persistent volume claim, run the following `kubectl` command:

   ```bash
   kubectl create -f storageclass_existing_lustre.yaml
   kubectl create -f pvc_storageclass.yaml
   ```

## Check the installation

If you want to check your installation, you can optionally use an echo pod to confirm the driver is working.

To view timestamps in the console during writes, run the following commands:

1. Add the following code to the echo pod:

   ```bash
   while true; do echo $(date) >> /mnt/lustre/outfile; tail -1 /mnt/lustre/outfile; sleep 1; done
   ```

1. To view timestamps in the console during writes, run the following `kubectl` command:

   ```bash
   `kubectl logs -f lustre-echo-date`
   ```

## Next steps

- Learn how to [export files from your file system with an archive job](export-with-archive-jobs.md).
