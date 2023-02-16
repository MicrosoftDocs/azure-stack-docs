---
title: Use the Azure Lustre CSI Driver (Preview) for Kubernetes
description: How to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/16/2023
ms.reviewer: mayabishop
ms.date: 02/15/2023

# Intent: As an IT Pro, I want to be able to use a Lustre storage system with my apps deployed on Azure Kubernetes Service (AKS).
# Keyword: AKS Azure Kubernetes Service

---

# Use Azure Lustre CSI Driver (Preview) for Kubernetes

The Azure Lustre container support interface (CSI) driver for Kubernetes allows you to use an Azure Managed Lustre storage system with Kubernetes containers.

Kubernetes can simplify the process to configure and deploy virtual client endpoints for your Azure Managed Lustre workload. It can automate setup tasks like these:

- Create virtual machine scale sets (VMSS) used by AKS to run the pods
- Load the correct Lustre client software onto the VM instances
- Specify the Azure Managed Lustre mount point and propagate that information to the client pods

The Azure Lustre CSI Driver can automate the client software and mount tasks. The driver provides a CSI controller plugin as a deployment with two replicas (by default, this can be customized) and a CSI node plugin as a daemonset.

## Compatible Kubernetes versions

The Azure Lustre CSI driver is compatible with [Azure Kubernetes Service](/azure/aks/) (AKS). Other Kubernetes installations are not currently supported. Contact the Azure Managed Lustre team for more information.

The following container images are compatible with Azure Managed Lustre file systems.

| CSI driver version | Container image                                             | Supported Kubernetes version | Lustre client version |
|--------------------|-------------------------------------------------------------|------------------------------|-----------------------|
| main branch        | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:latest | 1.21 or later | 2.15.1 |
| v0.1.5             | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.5 | 1.21 or later | 2.15.1 |

## Use Azure Managed Lustre storage system with Kubernetes

To use the Azure Managed Lustre CSI Driver for Kubernetes, follow these steps:

1. Plan your [network architecture](#provide-subnet-access-between-aks-and-azure-managed-lustre).

   Because the Azure Managed Lustre system operates within a private subnet, you must make sure your Kubernetes system can access that subnet. For supported options, see [Provide subnet access to the Azure Managed Lustre cluster](#provide-subnet-access-between-aks-and-azure-managed-lustre).

   > [!TIP]
   > Network access is easier to configure if your Azure Managed Lustre file system uses the same Azure subscription and virtual network (VNet) as your Azure Kubernetes Service system.

1. Create an [Azure Managed Lustre](create-file-system-portal.md) file system.

   Currently, the driver can only be used with a pre-existing Azure Managed Lustre system.

1. Create an [Azure Kubernetes Service](#create-and-connect-to-an-azure-kubernetes-service-cluster) instance, if you don't already have one.

1. [Connect to your AKS instance](#create-and-connect-to-an-azure-kubernetes-service-cluster).

1. [Clone and download the Azure Lustre CSI Driver for Kubernetes](#install-the-csi-driver) from the GitHub Kubernetes SIGs repository.

1. In your clone of the driver repository:

    1. [Install the driver components](#install-the-csi-driver).
    1. [Create and configure a persistent volume](#create-and-configure-a-persistent-volume).
    1. Optionally, [use an echo pod](#check-installation) to confirm that the driver is working.

The rest of this article gives instructions for each of these steps.

## Provide subnet access between AKS and Azure Managed Lustre

Because the Azure Managed Lustre file system operates within a private virtual network, you need to make sure your Kubernetes containers have a subnet in common with the Lustre cluster.

This section describes three options for subnet access.

### Option 1: Create an AKS subnet inside the Azure Managed Lustre VNet

Option 1 is to create a new subnet within your Azure Managed Lustre VNet and use it with AKS's Azure Container Network Interface (Azure CNI).

![Diagram showing Azure Managed Lustre VNet with two subnets, one for the Lustre file system and one for AKS.](media/use-csi-driver-kubernetes/subnet-access-option-1.png)

- This option doesn't require VNet peering.
- The new subnet must have enough IP addresses to support your AKS cluster. For example, a 50-node AKS cluster probably needs at least 2,048 IP addresses (CIDR notation /21).

  For sizing details, including a formula for calculating IP requirements, see [Configure Azure CNI networking in Azure Kubernetes Service](/azure/aks/configure-azure-cni).

  Alternatively, you could host the AKS cluster within your Azure Managed Lustre subnet instead of creating a separate subnet. In this case, make sure that your Lustre file system subnet has enough IP addresses to support both the Azure Managed Lustre system and the AKS cluster.

### Option 2: Use Azure CNI in AKS and peer the VNets

In this scenario, you create a new VNet and subnet, configure the subnet with Azure CNI networking in AKS, and then peer the new AKS VNet with the VNet that contains your Lustre file system.

![Diagram showing two VNets, one for Azure Managed Lustre and one for AKS, with a VNet peering arrow connecting them.](media/use-csi-driver-kubernetes/subnet-access-option-2.png)

- Size the subnet to support your AKS cluster, as described in [Configure Azure CNI networking in Azure Kubernetes Service](/azure/aks/configure-azure-cni).
- Read [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to learn how to connect the two networks.

### Option 3: Use AKS `kubenet`, and peer its VNet with the Azure Managed Lustre VNet

In this scenario, you use the AKS default `kubenet` style network for your AKS cluster. This automatically creates a new AKS-managed VNet and subnet. Then peer the AKS VNet with the Azure Managed Lustre VNet.

![Diagram showing two VNets, one for Azure Managed Lustre and one for AKS, which is managed by kubenet. A VNet peering arrow connects the two VNets.](media/use-csi-driver-kubernetes/subnet-access-option-3.png)

With this option, you don't have to explicitly create or size the VNet and subnet. `kubenet` automatically creates an appropriately sized subnet for your AKS cluster.

- The AKS VNet is created in a separate resource group from the AKS cluster's resource group. Look for a resource group with a name that starts with **MC_** and includes the name of your AKS cluster. The AKS VNet and related components are in this separate resource group.
- Learn more about [AKS networking and kubenet](/azure/aks/concepts-network#kubenet-basic-networking)
- Read [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to learn how to connect the two networks.

## Create and connect to an Azure Kubernetes Service cluster

If you haven't already done so, create and connect to your AKS instance.

Read [Deploy an Azure Kubernetes Service (AKS) cluster](/azure/aks/learn/quick-kubernetes-deploy-portal) for details.

After your AKS cluster is created, connect to it. In the Azure portal overview for your AKS cluster, select the **Get started** tab, then the **Connect** button to see CLI commands populated with your AKS cluster values.

Connect from the system where you will install and administer the CSI driver.

The following command is the basic connect command:

```azurecli
az aks get-credentials --subscription <AKS_subscription_id> --resource group <AKS_resource_group_name> --name <name_of_AKS>
```

## Install the CSI driver

Follow these instructions to install and configure the Azure Managed Lustre CSI driver.

The driver is provided in the GitHub Kubernetes SIGs repository as [Azure Lustre CSI Driver for Kubernetes](https://github.com/kubernetes-sigs/azurelustre-csi-driver).<!--Link target must be publicly available.-->

The **deploy** directory contains a script that installs the driver. Clone and download the repository to get the software:

```bash
git clone https://github.com/kubernetes-sigs/azurelustre-csi-driver.git
cd azurelustre-csi-driver
```

Next, switch to the **deploy/** path and run the installation script (https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/deploy/install-driver.sh):

```bash
cd deploy/
./install-driver.sh
```

> [!TIP]
> The documentation file **azurelustre-csi-driver/docs/install-csi-driver.md** (available online at https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/install-csi-driver.md) has examples and guidance for this step.<!--Link target must be publicly available.-->

The installation script uses `kubectl` to apply several configuration files to your environment. If you are installing from a system that doesn't have `kubectl` installed, follow the instructions [Connect to the AKS cluster](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) to connect to the cluster and access `kubectl`.

## Create and configure a persistent volume

The documentation file **docs/static-provisioning.md** (online at https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/static-provisioning.md) explains two methods for creating and configuring a persistent volume, but only Option 1, which uses the **storageclass_existing_lustre.yaml** configuration file, is supported in this preview.

### Option 1: Use "storage class" (recommended)

**WILL THERE BE AN OPTION 2? If not remove OPTION 1 subheading.**

This is the recommended method to create a persistent volume for an existing Azure Managed Lustre file system.

1. Copy these configuration files into your working path:
   - **azurelustre-csi-driver/docs/examples/storageclass_existing_lustre.yaml**
   - **azurelustre-csi-driver/docs/examples/pvc_storageclass.yaml**

   You can download these files without cloning the repository by opening the following links and copying the file contents. Paste the contents into a local file with the same filename.

   - **storageclass_existing_lustre.yaml**: https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/storageclass_existing_lustre.yaml<!--Link target must be publicly available.-->

   - **pvc_storageclass.yaml**: https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/examples/pvc_storageclass.yaml<!--Link target must be publicly available.-->

1. Update the following values in the **storageclass_existing_lustre.yaml** file.

   ![Screenshot of storageclass_existing_lustre.yaml file with values to replace highlighted.](media/use-csi-driver-kubernetes/storageclass-values-highlighted.png)

   1. Replace `EXISTING_LUSTRE_FS_NAME` with the system-assigned internal name of the Lustre cluster in your Azure Managed Lustre file system. In nearly all cases, this will be `lustrefs`.

      > [!NOTE]
      > This is not the same as the name you gave the file system when you created it.

      You can double-check the name on your file system's **Client connection** page in the portal. The suggested `mount` command on that page includes the name in an address string: <MGS_IP_address>``@tcp``<cluster_internal_name>.

   1. Replace `EXISTING_LUSTRE_IP_ADDRESS` with your Azure Managed Lustre file system's MGS IP address. You can find the address on the **Client connection** portal page.

      ![Screenshot of Azure portal Client connection page with highlight boxes around the value for "MGS IP address" and the 'lustrefs' name in the mount command string.](media/use-csi-driver-kubernetes/portal-mount-values-highlighted.png)

1. Use the files to create the storage class and the persistent volume claim:

   ```bash
   kubectl create -f storageclass_existing_lustre.yaml
   kubectl create -f pvc_storageclass.yaml
   ```

================
**REMOVE OPTION 2? Steps have been commented out.**

### Option 2: Use "pv" - *Unsupported*

**The PV method is unsupported in this release.**

<!-- 
1. Copy these configuration files into your working path:
    1. ``azurelustre-csi-driver/docs/examples/pv.yaml``
    1. ``azurelustre-csi-driver/docs/examples/pvc_pv.yaml``

1. Update the ``pv.yaml`` file with these values. You can find the first two values on your file system's **Client connection** page in the Azure portal.
    1. Replace ``EXISTING_LUSTRE_FS_NAME`` with your Azure Managed Lustre file system name
    1. Replace ``EXISTING_LUSTRE_IP_ADDRESS`` with your Azure Managed Lustre file system's MGS IP address
    1. Replace ``UNIQUE_IDENTIFIER_VOLUME_ID`` with a unique identifier

       ***[ ? - do you just make one up or is this from somewhere? config file says "Make sure this VolumeID is unique in the cluster". - ? ]***

1. Use the files to create the storage class and the persistent volume claim:

   ```bash
   kubectl create -f pv.yaml
   kubectl create -f pvc_pv.yaml
   ``` -->
================

## Check installation

Optionally, you can update the echo pod content to write a timestamp log.

Add the following code to the echo pod:

```bash
while true; do echo $(date) >> /mnt/lustre/outfile; tail -1 /mnt/lustre/outfile; sleep 1; done
```

<!-- ***[ ? - wait, is there a sample file for this in the repo now? azurelustre-csi-driver/docs/examples/pod_echo_date.yaml - yes but it needs an update - ? ]*** -->

After that, you can run `kubectl logs -f lustre-echo-date` to see timestamps print on the console during writes.
