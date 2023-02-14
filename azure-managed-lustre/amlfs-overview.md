---
title: What is Azure Managed Lustre (Preview)?
description: Use Azure Managed Lustre to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/13/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, I want to understand how to use an Azure Managed Lustre file system xxx.
# Keyword: 

---
# What is Azure Managed Lustre (Preview)?

<!--STATUS: Source content compiled from existing Private Preview overviews. Links not added. Organization needs work. Product team to review for needed content.-->

The Azure Managed Lustre service gives you the capability to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.

Lustre is an open-source parallel file system that can scale to massive storage sizes while also providing high performance throughput. It's used by the world's fastest supercomputers and in data-centric workflows for many types of industries. For more information, see [https://www.lustre.org](https://www.lustre.org).

Azure Managed Lustre saves you the work of provisioning, configuring, and managing your own Lustre file system. Using a **Create** command in the Azure portal, you can quickly deploy a Lustre file system in the size that you need, connect your clients, and be ready to use the system.

Microsoft Azure Blob Storage is integrated with Azure Managed Lustre, which allows you to specify files to import from a blob container for the file system's use. Azure Blob Storage integration is an application of Lustre hierarchical storage management (HSM). There's no need to import your entire data set for every job. Instead, you can create a different file system for different jobs and store data in lower-cost Azure blob containers between uses. When the high-performance computing jobs are finished, you can export changed data to Azure Blob Storage, and delete the Azure Managed Lustre system.

## To join the public preview

IN DEVELOPMENT (two sentences):

* About the public preview
* How to sign up
* Cost?
* Support policies

## Data security in Azure Managed Lustre

All data stored in Azure is encrypted at rest using Microsoft-managed keys by default. If you want to manage the keys used to encrypt your data when it's stored in your Azure Managed Lustre cluster, follow the instructions in [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

All information in an Azure Managed Lustre file system also is protected by VM host encryption on the managed disks that hold your data, even if you add a customer-managed key for the Lustre disks. Adding a customer-managed key gives an extra level of security for customers with high security needs. For more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

## Data resilience in Azure Managed Lustre

When you create an Azure Managed Lustre file system, the cloud-based Lustre system is pre-configured based on the storage size and throughput values you chose.

You can see some of the properties on the file system **Overview** page in the Azure portal. Click the **JSON view** link for more details.
<!--QUESTIONS: 1) From the Overview blade for a file system deployment, Json view link is only available after they Go to resource group. 2) The Json view doesn't show much in a minimal default deployment. What will they be looking for?-->

[ADD SCREENSHOT: Summary & Json view detail]

## Data disks

Your Azure Managed Lustre file system uses Azure managed disks as object storage target (OST) data disks.

All Azure Managed Lustre file systems that are created as a "durable" file system type use Azure Premium SSD (solid state drive) disks configured as locally redundant storage (LRS). LRS disk contents are replicated three times within the local datacenter to protect against drive and server rack failures. This redundancy provides 99.99999 percent durability.<!--Do we provide this type of statistical assurance in Learning content? Better to link to another source for this?-->

The Lustre file system itself also contributes to data resilience through the object storage processes it uses to store data on these disks.

If you need regional or global data redundancy, you can integrate your file system with Azure Blob Storage and use archive jobs to export files to an Azure Blob Storage container with a different redundancy policy for long-term storage. Configure Azure Blob Storage redundancy for the storage account. You can choose zonal data redundancy (ZRS) or global data redundancy (GRS) when you create the storage account. To learn more about data redundancy options for your Azure Managed Lustre files, see [Supported storage account types](amlfs-requirements.md#supported-storage-account-types].

## Azure Blob Storage integration

<!--Source: Use Azure Blob Storage with Azure Managed Lustre - Will be included in the public preview docs.-->

Azure Managed Lustre is customized to work seamlessly with Azure Blob Storage. You can specify an existing blob container to make its data accessible from your Azure Managed Lustre file system, or specify an empty container that you populate with data or use to store your output. All of the setup and maintenance is done for you - you just need to specify which blob container to use.

If you integrate Azure Blob Storage when you create a Lustre file system, you can use Lustre Hierarchical Storage Management (HSM) features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

Read the Lustre HSM documentation - GET LINK - to learn more about how Lustre HSM works.

## Use Azure Managed Lustre with Kubernetes

If you want to use an Azure Managed Lustre storage system with your Kubernetes containers, you can use the Azure Lustre container support interface (CSI) driver for Kubernetes, which is compatible with Azure Kubernetes Service (AKS). Other types of Kubernetes installation currently aren't supported.

Kubernetes can simplify configuring and deploying virtual client endpoints for your Azure Managed Lustre workload, automating setup tasks such as:

* Creating virtual machine scale sets (VMSS) used by Azure Kubernetes Service (AKS) to run the pods.
* Loading the correct Lustre client software on VM instances.
* Specifying the Azure Managed Lustre mount point, and propagating that information to the client pods.

The Azure Lustre CSI driver for Kubernetes can automate installing the client software and mounting drives. The driver provides a CSI controller plugin<!--Check plugin name.--> as a deployment with two replicas by default, and a CSI node plugin<!--Check plugin name.--> as a daemonset.

To find out which driver versions to use, see [Compatible Kubernetes versions](amlfs-requirements.md#compatible-kubernetes-versions) in [Azure Managed Lustre file system requirements](amlfs-requirements.md).