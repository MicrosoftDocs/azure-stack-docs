---
title: What is Azure Managed Lustre?
description: Use Azure Managed Lustre to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 06/28/2023
ms.reviewer: mayabishop
ms.custom: references_regions

# Intent: As an IT Pro, I want to understand how to use an Azure Managed Lustre file system.
# Keyword: 

---

# What is Azure Managed Lustre?

The Azure Managed Lustre service gives you the capability to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.

Lustre is an open-source parallel file system that can scale to massive storage sizes while also providing high performance throughput. Lustre is used by the world's fastest supercomputers and in data-centric workflows for many types of industries. For more information, see [https://www.lustre.org](https://www.lustre.org).

Azure Managed Lustre saves you the work of provisioning, configuring, and managing your own Lustre file system. Using a **Create** command in the Azure portal, you can quickly deploy a Lustre file system in the size that you need, connect your clients, and be ready to use the system.

Microsoft Azure Blob Storage is integrated with Azure Managed Lustre, which allows you to specify files to import from a blob container for the file system's use. When the high-performance computing jobs are finished, you can export changed data to Azure Blob Storage, and delete the Azure Managed Lustre system. For more information, see [Azure Blob Storage integration](#azure-blob-storage-integration), later in this article.

You can also use your Azure Managed Lustre file system with your Azure Kubernetes Service (AKS) containers. For more information, see [Use Azure Managed Lustre with Kubernetes](#use-azure-managed-lustre-with-kubernetes).

## Data security in Azure Managed Lustre

All data stored in Azure is encrypted at rest using Azure managed keys by default. If you want to manage the keys used to encrypt the data stored in your Azure Managed Lustre cluster, follow the instructions in [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

All information in an Azure Managed Lustre file system also is protected by VM host encryption on the managed disks that hold your data, even if you add a customer-managed key for the Lustre disks. Adding a customer-managed key gives an extra level of security for customers with high security needs. For more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

> [!NOTE]
> Azure Managed Lustre doesn't store customer data outside the region in which you deploy the service instance.

## Data resilience in Azure Managed Lustre

Your Azure Managed Lustre file system uses Azure managed disks as object storage target (OST) data disks.

All Azure Managed Lustre file systems that are created as a "durable" file system type use Azure Premium SSD (solid state drive) disks configured as locally redundant storage (LRS). LRS disk contents are replicated three times within the local datacenter to protect against drive and server rack failures.

The Azure Managed Lustre file system itself also contributes to data resilience through the object storage processes it uses to store data on these disks.

If you need regional or global data redundancy, you can integrate your file system with Azure Blob Storage. Once integrated, you can use archive jobs to export files to an Azure Blob Storage container with a different redundancy policy for long-term storage. Configure Azure Blob Storage redundancy for the storage account. You can choose zonal data redundancy (ZRS) or global data redundancy (GRS) when you create the storage account. To learn more about data redundancy options for your Azure Managed Lustre files, see [Supported storage account types](amlfs-prerequisites.md#supported-storage-account-types).

## Azure Blob Storage integration

Microsoft Azure Blob Storage is integrated with Azure Managed Lustre, which allows you to specify files to import from a blob container for the file system's use. Azure Blob Storage integration is an application of Lustre hierarchical storage management (HSM). There's no need to import your entire data set for every job. Instead, you can create a different file system for different jobs and store data in lower-cost Azure blob containers between uses. When the high-performance computing jobs are finished, you can export changed data to Azure Blob Storage, and delete the Azure Managed Lustre system.

Azure Managed Lustre is customized to work seamlessly with Azure Blob Storage. You can specify an existing blob container to make its existing data accessible from your Azure Managed Lustre file system, or specify an empty container that you populate with data or use to store your output. Setup and maintenance are done for you. You just specify which blob container to use.

If you integrate Azure Blob Storage when you create a Lustre file system, you can use Lustre HSM features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

## Use Azure Managed Lustre with Kubernetes

If you want to use an Azure Managed Lustre storage system with your Kubernetes containers, you can use the Azure Lustre container support interface (CSI) driver for Kubernetes, which is compatible with Azure Kubernetes Service (AKS). Other types of Kubernetes installation aren't currently supported.

Kubernetes can simplify configuring and deploying virtual client endpoints for your Azure Managed Lustre workload, automating setup tasks such as:

* Creating Azure Virtual Machine Scale Sets used by Azure Kubernetes Service (AKS) to run the pods.
* Loading the correct Lustre client software on VM instances.
* Specifying the Azure Managed Lustre mount point, and propagating that information to the client pods.

The Azure Lustre CSI driver for Kubernetes can automate installing the client software and mounting drives. The driver provides a CSI controller plugin as a deployment with two replicas by default, and a CSI node plugin, as a DaemonSet. You can change the number of replicas.

To find out which driver versions to use, see [Compatible Kubernetes versions](use-csi-driver-kubernetes.md#compatible-kubernetes-versions).

## Next steps

- Learn more about [blob storage integration](blob-integration.md)
- Learn more about [using Azure Managed Lustre with Kubernetes](use-csi-driver-kubernetes.md)
