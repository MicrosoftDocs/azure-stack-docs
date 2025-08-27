---
title: Use the Azure Managed Lustre CSI Driver with Azure Kubernetes Service
description: Learn how to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
ms.date: 01/10/2025
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to be able to use a Lustre file system with the apps I've deployed on Kubernetes.
# Keyword: 

---

# Use the Azure Managed Lustre CSI driver with Azure Kubernetes Service

In this article, you learn how to plan, install, and use [Azure Managed Lustre](/azure/azure-managed-lustre) in [Azure Kubernetes Service (AKS)](/azure/aks/) with the [Azure Lustre CSI Driver for Kubernetes](https://github.com/kubernetes-sigs/azurelustre-csi-driver). This driver is based on the Container Support Interface (CSI) specification.

You can use the Azure Lustre CSI Driver for Kubernetes to access Azure Managed Lustre storage as persistent storage volumes from Kubernetes containers deployed in AKS.

## Compatible Kubernetes versions

The Azure Lustre CSI Driver for Kubernetes is compatible with [AKS](/azure/aks/). Other Kubernetes installations are not currently supported.

AKS Kubernetes versions 1.21 and later are supported. This support includes all versions currently available when you're creating a new AKS cluster.

> [!IMPORTANT]
> The Azure Lustre CSI Driver for Kubernetes currently works only with the Ubuntu Linux OS SKU for node pools of AKS.

## Compatible Lustre versions

The Azure Lustre CSI Driver for Kubernetes is compatible with [Azure Managed Lustre](/azure/azure-managed-lustre). Other Lustre installations are not currently supported.  

Azure Lustre CSI Driver for Kubernetes versions 0.1.10 and later are supported with the current version of the Azure Managed Lustre service.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/).
- A terminal environment with the Azure CLI tools installed. See [Get started with the Azure CLI](/cli/azure/get-started-with-azure-cli).
- [kubectl](https://kubernetes.io/docs/reference/kubectl), the Kubernetes management tool, installed in your terminal environment. See [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure CLI](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).
- An Azure Managed Lustre deployment. See the [Azure Managed Lustre documentation](/azure/azure-managed-lustre).

## Plan your AKS deployment

When you're deploying Azure Kubernetes Service, several options affect the operation between AKS and Azure Managed Lustre.

### Determine the network type to use with AKS

Two network types are compatible with the Ubuntu Linux OS SKU: kubenet and the Azure Container Network Interface (CNI) driver. Both options work with the Azure Lustre CSI Driver for Kubernetes, but they have different requirements that you need understand when you're setting up virtual networking and AKS. For more information on determining the proper selection, see [Networking concepts for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-network).

### Determine the network architecture for interconnectivity of AKS and Azure Managed Lustre

Azure Managed Lustre operates within a private virtual network. Your AKS instance must have network connectivity to the Azure Managed Lustre virtual network. There are two common ways to configure the networking between Azure Managed Lustre and AKS:

- Install AKS in its own virtual network and create a virtual network peering with the Azure Managed Lustre virtual network.
- Use the **Bring your own Azure virtual network** option in AKS to install AKS in a new subnet on the Azure Managed Lustre virtual network.

> [!NOTE]
> We don't recommend that you install AKS in the same subnet as Azure Managed Lustre.

#### Peering AKS and Azure Managed Lustre virtual networks

The option to peer two virtual networks has the advantage of separating the management of the networks into different privileged roles. Peering can also provide additional flexibility, because you can implement it across Azure subscriptions or regions. Virtual network peering requires coordination between the two networks to avoid choosing conflicting IP network spaces.

![Diagram that shows two virtual networks, one for Azure Managed Lustre and one for AKS, with a peering arrow connecting them.](media/use-csi-driver-kubernetes/subnet-access-option-2.png)

#### Installing AKS in a subnet on the Azure Managed Lustre virtual network

The option to install the AKS cluster in the Azure Managed Lustre virtual network with the **Bring your own Azure virtual network** feature in AKS can be advantageous in scenarios where the network is managed singularly. You'll need to create an additional subnet, sized to meet your AKS networking requirements, in the Azure Managed Lustre virtual network.

There is no privilege separation for network management when you're provisioning AKS on the Azure Managed Lustre virtual network. The AKS service principal needs privileges on the Azure Managed Lustre virtual network.

![Diagram that shows an Azure Managed Lustre virtual network with two subnets, one for the Lustre file system and one for AKS.](media/use-csi-driver-kubernetes/subnet-access-option-1.png)

## Set up the driver

To enable the Azure Lustre CSI Driver for Kubernetes, perform these steps:

1. [Create an Azure Managed Lustre file system cluster](#create-an-azure-managed-lustre-file-system-cluster).

1. [Create an AKS cluster](#create-an-aks-cluster).

1. [Create a virtual network peering](#create-a-virtual-network-peering).

1. [Install the driver](#install-the-driver).

1. [Create and configure a persistent volume](#create-and-configure-a-persistent-volume).

1. [Check the installation](#check-the-installation) by optionally using an echo pod to confirm that the driver is working.

The following sections describe each task in greater detail.

### Create an Azure Managed Lustre file system cluster

If you haven't already created your Azure Managed Lustre file system cluster, create the cluster now. For instructions, see [Create an Azure Managed Lustre file system by using the Azure portal](create-file-system-portal.md). Currently, the driver can be used only with an existing Azure Managed Lustre file system.

### Create an AKS cluster

If you haven't already created your AKS cluster, create a cluster deployment. See [Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure portal](/azure/aks/learn/quick-kubernetes-deploy-portal).

### Create a virtual network peering

> [!NOTE]
> Skip this network peering step if you installed AKS in a subnet on the Azure Managed Lustre virtual network.

The AKS virtual network is created in a separate resource group from the AKS cluster's resource group. You can find the name of this resource group by going to your AKS cluster in the Azure portal, going to **Properties**, and finding the **Infrastructure** resource group. This resource group contains the virtual network that needs to be paired with the Azure Managed Lustre virtual network. It matches the pattern **MC\_\<aks-rg-name\>\_\<aks-cluster-name\>\_\<region\>**.

To peer the AKS virtual network with your Azure Managed Lustre virtual network, consult [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

> [!TIP]
> Due to the naming of the MC_ resource groups and virtual networks, names of networks can be similar or the same across multiple AKS deployments. When you're setting up peering, be careful to choose the AKS networks that you intend to choose.

### Connect to the AKS cluster

1. Open a terminal session with access to the Azure CLI tools and sign in to your Azure account:

   ```azurecli
   az login
   ```

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Find your AKS cluster. On the **Overview** pane, select the **Connect** button, and then copy the command for **Download cluster credentials**.

1. In your terminal session, paste in the command to download the credentials. The command is similar to:

   ```azurecli
   az aks get-credentials --subscription <AKS_subscription_id> --resource_group <AKS_resource_group_name> --name <name_of_AKS>
   ```

1. Install kubectl if it's not present in your environment:

   ```azurecli
   az aks install-cli
   ```

1. Verify that the current context is the AKS cluster where you just installed the credentials and that you can connect to it:

   ```bash
   kubectl config current-context
   kubectl get deployments --all-namespaces=true
   ```

### Install the driver

To install the Azure Lustre CSI Driver for Kubernetes, run the following command:

```bash
curl -skSL https://raw.githubusercontent.com/kubernetes-sigs/azurelustre-csi-driver/main/deploy/install-driver.sh | bash
```

To get sample commands for a local installation, see [Install the Azure Lustre CSI driver on a Kubernetes cluster](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/install-csi-driver.md).

### Create and configure a persistent volume

To create a persistent volume for an existing Azure Managed Lustre file system:

1. Copy the following configuration files from the **/docs/examples/** folder in the [azurelustre-csi-driver](https://github.com/kubernetes-sigs/azurelustre-csi-driver/tree/main/docs/examples) repository. If you cloned the repository when you [installed the driver](#install-the-driver), you have local copies available already.

   - **storageclass_existing_lustre.yaml**
   - **pvc_storageclass.yaml**

   If you don't want to clone the entire repository, you can download each file individually. Open each of the following links, copy the file's contents, and then paste the contents into a local file with the same file name.

   - [storageclass_existing_lustre.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/storageclass_existing_lustre.yaml)
   - [pvc_storageclass.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/pvc_storageclass.yaml)

1. In the **storageclass_existing_lustre.yaml** file, update the internal name of the Lustre cluster and the Lustre Management Service (MGS) IP address.

   ![Screenshot of the storageclass_existing_lustre.yaml file with values to replace highlighted.](media/use-csi-driver-kubernetes/storageclass-values-highlighted.png)

   Both settings are displayed in the Azure portal, on the **Client connection** pane for your Azure Managed Lustre file system.

   ![Screenshot of the pane for client connection in the Azure portal. The MGS IP address and the "lustrefs" name in the mount command are highlighted.](media/use-csi-driver-kubernetes/portal-mount-values-highlighted.png)

   Make these updates:

   - Replace `EXISTING_LUSTRE_FS_NAME` with the system-assigned internal name of the Lustre cluster in your Azure Managed Lustre file system. The internal name is usually `lustrefs`. The internal name isn't the name that you gave the file system when you created it.

     The suggested `mount` command includes the name highlighted in the following address string.

     ![Screenshot of a sample address string on the pane for client connection. The internal name of the Lustre cluster is highlighted.](media/use-csi-driver-kubernetes/portal-mount-address-string.png)

   - Replace `EXISTING_LUSTRE_IP_ADDRESS` with the MGS IP address.

1. To create the storage class and the persistent volume claim, run the following `kubectl` command:

   ```bash
   kubectl create -f storageclass_existing_lustre.yaml
   kubectl create -f pvc_storageclass.yaml
   ```

### Check the installation

If you want to check your installation, you can optionally use an echo pod to confirm that the driver is working.

To view time stamps in the console during writes, run the following commands:

1. Add the following code to the echo pod:

   ```bash
   while true; do echo $(date) >> /mnt/lustre/outfile; tail -1 /mnt/lustre/outfile; sleep 1; done
   ```

1. To view time stamps in the console during writes, run the following `kubectl` command:

   ```bash
   `kubectl logs -f lustre-echo-date`
   ```

## Related content

- [Create an export job to export data from Azure Managed Lustre](export-with-archive-jobs.md)
