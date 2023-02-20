---
title: Use the Azure Lustre CSI Driver (preview) for Kubernetes
description: How to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/20/2023
ms.reviewer: brianl
ms.date: 02/17/2023

# Intent: As an IT Pro, I want to be able to use a Lustre file system with the apps I've deployed on Kubernetes.
# Keyword: 

---

# Use the Azure Lustre CSI Driver (preview) for Kubernetes

The Azure Lustre container support interface (CSI) driver for Kubernetes enables you to use an Azure Managed Lustre storage system with Kubernetes containers. The driver is compatible with [Azure Kubernetes Service (AKS)](/azure/aks/).

Kubernetes can simplify the process to configure and deploy virtual client endpoints for your Azure Managed Lustre workload. It can automate setup tasks like these:

- Create Virtual Machine Scale Sets used by AKS to run the pods.
- Load the correct Lustre client software onto the VM instances.
- Specify the Azure Managed Lustre mount point, and propagate that information to the client pods.

The Azure Lustre CSI driver can automate the client software and mount tasks. The driver provides a CSI controller plugin as a deployment with two replicas, by default, and a CSI node plugin as a daemonset. You can change the number of replicas.

## Compatible Kubernetes versions

The Azure Lustre CSI driver is compatible with [Azure Kubernetes Service](/azure/aks/) (AKS). Other Kubernetes installations aren't currently supported.

The following container images are compatible with Azure Managed Lustre file systems.

| CSI driver version | Container image                                               | Supported Kubernetes version | Lustre client version |
|--------------------|---------------------------------------------------------------|------------------------------|-----------------------|
| main branch        | `mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:latest` | 1.21 or later | 2.15.1 |
| v0.1.5             | `mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.5` | 1.21 or later | 2.15.1 |

## Setup overview

To use the Azure Managed Lustre CSI driver for Kubernetes, you'll complete these tasks:

1. [Provide subnet access between AKS and your Azure Managed Lustre file system](#provide-subnet-access-between-aks-and-azure-managed-lustre).

1. [Create an Azure Managed Lustre file system](create-file-system-portal.md).

   Currently, the driver can only be used with a pre-existing Azure Managed Lustre system.

1. [Create an Azure Kubernetes Service instance](#create-aks-cluster) if you don't already have one.

1. [Connect to your AKS instance](#connect-to-aks-cluster).

1. [Install the Azure Lustre CSI driver for Kubernetes](#install-csi-driver).



In your clone of the driver repository:

    1. [Install the driver components](#install-csi-driver).
    1. [Create and configure a persistent volume](#create-and-configure-a-persistent-volume).
    1. Optionally, [use an echo pod](#check-the-installation) to confirm that the driver is working.
   
The rest of this article gives instructions for each of these steps.<!--UGH-->

## Provide subnet access between AKS and Azure Managed Lustre

Because the Azure Managed Lustre file system operates within a private virtual network, your Kubernetes containers must have a subnet in common with the Lustre cluster. There are three ways to configure subnet access.

> [!TIP]
> Network access is easier to configure if your Azure Managed Lustre file system and your Azure Kubernetes Service system use the same subscription and virtual network (VNet).

### Option 1: Create an AKS subnet inside the Azure Managed Lustre VNet

You can create a new subnet within your Azure Managed Lustre VNet, and use that subnet with the Azure Container Network Interface (Azure CNI) for AKS. Or you can host the AKS cluster within your Azure Managed Lustre subnet.

![Diagram showing Azure Managed Lustre VNet with two subnets, one for the Lustre file system and one for AKS.](media/use-csi-driver-kubernetes/subnet-access-option-1.png)

If you use this option, XXX the following considerations:

- This option doesn't require VNet peering.

- If you create a new subnet, the subnet must have enough IP addresses to support your AKS cluster. For example, a 50-node AKS cluster probably needs at least 2,048 IP addresses (CIDR notation /21).

  For sizing details, including a formula for calculating IP requirements, see [Configure Azure CNI networking in Azure Kubernetes Service](/azure/aks/configure-azure-cni).

- If you host the AKS cluster within your Azure Managed Lustre subnet, make sure your Lustre file system subnet has enough IP addresses to support both the Azure Managed Lustre system and the AKS cluster.

### Option 2: Use Azure CNI in AKS, and peer the VNets

A second option is to create a new VNet and subnet, configure the subnet with Azure CNI networking in AKS, and then peer the new AKS VNet with the VNet that contains your Lustre file system.

![Diagram showing two VNets, one for Azure Managed Lustre and one for AKS, with a VNet peering arrow connecting them.](media/use-csi-driver-kubernetes/subnet-access-option-2.png)

- Size the subnet to support your AKS cluster, as described in [Configure Azure CNI networking in Azure Kubernetes Service](/azure/aks/configure-azure-cni).

- To learn how to connect the two networks, see [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

### Option 3: Use AKS `kubenet`, and peer its VNet with the Azure Managed Lustre VNet

A third option is to use the AKS default `kubenet`-style network for your AKS cluster. A new AKS-managed VNet and subnet are created automatically. You'll then peer the AKS VNet with the Azure Managed Lustre VNet.

![Diagram showing two VNets, one for Azure Managed Lustre and one for AKS, which is managed by kubenet. A VNet peering arrow connects the two VNets.](media/use-csi-driver-kubernetes/subnet-access-option-3.png)

- With this option, you don't have to create or size the VNet and subnet. `kubenet` automatically creates an appropriately sized subnet for your AKS cluster.

- The AKS VNet is created in a separate resource group from the AKS cluster's resource group. Look for a resource group with a name that starts with **MC_** and includes the name of your AKS cluster. This resource group contains the AKS VNet and related components.

  For more information, see [Kubenet (basic) networking](/azure/aks/concepts-network#kubenet-basic-networking) in [Network concepts for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-network#kubenet-basic-networking).

- To learn how to connect the two networks, see [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

## Create and connect to Azure Kubernetes Service cluster

If you haven't already done so, create and connect to your Azure Kubernetes Service instance.

### Create AKS cluster

If you haven't already created your AKS cluster, create the cluster now. For instructions, see [Deploy an Azure Kubernetes Service (AKS) cluster](/azure/aks/learn/quick-kubernetes-deploy-portal).

### Connect to AKS cluster

Connect to the cluster by doing these steps:

1. In the Azure preview portal, on the **Overview** page for your AKS cluster, select the **Get started** tab.

   To see CLI commands populated with your AKS cluster values, select **Connect**.

1. Open a PowerShell session on the system where you'll install and administer the CSI driver.

1. To connect, run the following basic connect command in Azure CLI, substituting the settings for your AKS cluster:

   ```azurecli
   az aks get-credentials --subscription <AKS_subscription_id> --resource group <AKS_resource_group_name> --name <name_of_AKS>
   ```

## Install the CSI driver

The CSI driver is available in the GitHub Kubernetes SIGs repository, at [https://github.com/kubernetes-sigs/azurelustre-csi-driver](https://github.com/kubernetes-sigs/azurelustre-csi-driver). The **Deploy** folder includes a script that installs the driver.

To install the CSI driver, do these steps:

1. Clone and download the repository to get the software by running the following command:

   ```bash
   git clone https://github.com/kubernetes-sigs/azurelustre-csi-driver.git
   cd azurelustre-csi-driver
   ```

2. Change directories to the **deploy/** subdirectory, and run the installation script, **install-driver-sh (at https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/deploy/install-driver.sh):

   ```bash
   cd deploy/
   ./install-driver.sh
   ```

   The installation script uses `kubectl` to apply several configuration files to your environment. If you're installing from a system that doesn't have `kubectl` installed, follow the instructions in [Connect to the AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) to connect to the cluster and access `kubectl`.

   For examples and guidance, see [Install Azure Lustre CSI driver on a Kubernetes cluster](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/install-csi-driver.md).

## Create and configure a persistent volume

Complete the following tasks to create and configure a persistent volume. For more information, see [Static provisioning](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/static-provisioning.md).

To create a persistent volume for an existing Azure Managed Lustre file system, do these steps:

1. Copy the following configuration files from **Examples** folder in the [azurelustre-csi-driver GItHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver/tree/main/docs) to your working path:

   - **azurelustre-csi-driver/docs/examples/storageclass_existing_lustre.yaml**
   - **azurelustre-csi-driver/docs/examples/pvc_storageclass.yaml**

   If you don't want to clone the entire repository, you can download each file individually. Open each of the following links, copy the file's contents, and then paste the contents into a local file with the same filename.

   - [storageclass_existing_lustre.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/storageclass_existing_lustre.yaml)

   - [pvc_storageclass.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/pvc_storageclass.yaml)

1. In the **storageclass_existing_lustre.yaml** file, update the internal name of the Lustre cluster and the MSG IP address.

   ![Screenshot of storageclass_existing_lustre.yaml file with values to replace highlighted.](media/use-csi-driver-kubernetes/storageclass-values-highlighted.png)

   Both settings are displayed in the Azure portal, on the **Client connection** page for your Azure Lustre file system.

   ![Screenshot of the Azure portal Client Connection page. The MGS IP address and the "lustrefs" name in the mount command are highlighted.](media/use-csi-driver-kubernetes/portal-mount-values-highlighted.png)

   - Replace `EXISTING_LUSTRE_FS_NAME` with the system-assigned internal name of the Lustre cluster in your Azure Managed Lustre file system. The internal name is usually `lustrefs`. The internal name is *not* the name that you gave the file system when you created it.

     The suggested `mount` command includes the name in an address string: `<MGS_IP_address>``@tcp``<cluster_internal_name>`

   - Replace `EXISTING_LUSTRE_IP_ADDRESS` with the MSG IP address for your Azure Managed Lustre file system.

1. To create the storage class and the persistent volume claim, run the following `kubectl` command:

   ```bash
   kubectl create -f storageclass_existing_lustre.yaml
   kubectl create -f pvc_storageclass.yaml
   ```

## Check the installation

To view timestamps in the console during writes, update the echo pod content to write a timestamp log by running the following commands:

1. Add the following code to the echo pod:

   ```bash
   while true; do echo $(date) >> /mnt/lustre/outfile; tail -1 /mnt/lustre/outfile; sleep 1; done
   ```

2. To view timestamps in the console during writes, run the following `kubectl` command:

   ```bash
   `kubectl logs -f lustre-echo-date`
   ```
