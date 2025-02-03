---
title: What is Azure Managed Lustre?
description: Use Azure Managed Lustre to quickly create an Azure-based Lustre file system for cloud-based high-performance computing jobs.
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 02/03/2025
ms.reviewer: mayabishop
ms.custom: references_regions

# Intent: As an IT Pro, I want to understand how to use an Azure Managed Lustre file system.
# Keyword: 

---

# What is Azure Managed Lustre?

Azure Managed Lustre is a managed file system that offers scalable, powerful, cost-effective storage for high-performance computing (HPC) workloads.

Here are some key features and benefits of Azure Managed Lustre:

- **Accelerate HPC workloads**: Offers a high-performance distributed parallel file system solution, ideal for HPC workloads that require high throughput, low latency, and Lustre protocol compatibility.
- **Purpose-built managed service**: Provides the benefits of a Lustre parallel file system without the complexity of managing the underlying infrastructure. Azure Managed Lustre is a fully managed service that simplifies operations, reduces setup costs, and eliminates complex maintenance.
- **Azure Blob Storage integration**: Allows you to connect Azure Managed Lustre file systems with Azure Blob Storage containers for optimal data placement and cost management. For more information, see [Azure Blob Storage integration](#azure-blob-storage-integration).
- **Azure Kubernetes Service (AKS) integration**: Allows you to containerize workloads using the available AKS-compatible CSI driver. For more information, see [Use Azure Managed Lustre with Kubernetes](#use-azure-managed-lustre-with-kubernetes).

Lustre is an open-source parallel file system that can scale to massive storage sizes while also providing high-performance throughput. Lustre is used by the world's fastest supercomputers and in data-centric workflows for many types of industries. For more information about Lustre, see [https://www.lustre.org](https://www.lustre.org).

## Data security in Azure Managed Lustre

All data stored in Azure is encrypted at rest using Azure managed keys by default. If you want to manage the keys used to encrypt the data stored in your Azure Managed Lustre cluster, follow the instructions in [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

All information in an Azure Managed Lustre file system is protected by virtual machine (VM) host encryption on the managed disks that hold your data, even if you add a customer-managed key for the Lustre disks. Adding a customer-managed key gives an extra level of security for customers with high security needs. For more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

> [!NOTE]
> Azure Managed Lustre doesn't store customer data outside the region in which you deploy the service instance.

## Data resilience in Azure Managed Lustre

Your Azure Managed Lustre file system uses Azure managed disks as object storage target (OST) data disks.

All Azure Managed Lustre file systems that are created as a "durable" file system type use Azure Premium SSD (solid-state drive) disks configured as locally redundant storage (LRS). LRS disk contents are replicated three times within the local data center to protect against drive and server rack failures.

The Azure Managed Lustre file system itself also contributes to data resilience through the object storage processes it uses to store data on these disks.

If you need regional or global data redundancy, you can integrate your file system with Azure Blob Storage. Once integrated, you can initiate an export job to export files to an Azure Blob Storage container with a different redundancy policy for long-term storage. Configure Azure Blob Storage redundancy for the storage account. You can choose zonal data redundancy (ZRS) or global data redundancy (GRS) when you create the storage account. To learn more about data redundancy options for your Azure Managed Lustre files, see [Supported storage account types](amlfs-prerequisites.md#supported-storage-account-types).

## Azure Blob Storage integration

Azure Blob Storage is integrated with Azure Managed Lustre, which allows you to specify files to import from a blob container for the file system's use. Azure Blob Storage integration is an application of Lustre hierarchical storage management (HSM). There's no need to import your entire data set for every job. Instead, you can create a different file system for different jobs and store data in lower-cost Azure blob containers between uses. When the high-performance computing jobs are finished, you can export changed data to Azure Blob Storage, and delete the Azure Managed Lustre system.

Azure Managed Lustre is customized to work seamlessly with Azure Blob Storage. You can specify an existing blob container to make its existing data accessible from your Azure Managed Lustre file system. You can also specify an empty container that you populate with data or use to store your output. Setup and maintenance are done for you. You just specify which blob container to use.

If you integrate Azure Blob Storage when you create a Lustre file system, you can use Lustre HSM features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

To learn more about this feature, see [Azure Blob Storage integration](blob-integration.md).

## Use Azure Managed Lustre with Kubernetes

If you want to use an Azure Managed Lustre storage system with your Kubernetes containers, you can use the Azure Lustre container support interface (CSI) driver for Kubernetes, which is compatible with Azure Kubernetes Service (AKS). Other types of Kubernetes installation aren't currently supported.

Kubernetes can simplify configuring and deploying virtual client endpoints for your Azure Managed Lustre workload, automating setup tasks such as:

- Creating Azure Virtual Machine Scale Sets used by Azure Kubernetes Service (AKS) to run the pods.
- Loading the correct Lustre client software on VM instances.
- Specifying the Azure Managed Lustre mount point, and propagating that information to the client pods.

The Azure Lustre CSI driver for Kubernetes can automate installing the client software and mounting drives. The driver provides a CSI controller plugin as a deployment with two replicas by default, and a CSI node plugin, as a DaemonSet. You can change the number of replicas.

To learn more about this feature, see [Use the Azure Managed Lustre CSI driver with Azure Kubernetes Service](use-csi-driver-kubernetes.md).

To find out which driver versions to use, see [Compatible Kubernetes versions](use-csi-driver-kubernetes.md#compatible-kubernetes-versions).

## Related content

- Deploy an Azure Managed Lustre file system using [Azure portal](create-file-system-portal.md), [Azure Resource Manager (ARM) templates](create-file-system-resource-manager.md), or [Terraform](create-aml-file-system-terraform.md).
- Learn more about [Blob Storage integration](blob-integration.md)
- Learn more about using [Azure Managed Lustre with Kubernetes](use-csi-driver-kubernetes.md)
