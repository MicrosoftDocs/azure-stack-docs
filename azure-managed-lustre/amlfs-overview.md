---
title: What is Azure Managed Lustre (Preview)?
description: Use Azure Managed Lustre to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, I want to understand how to use an Azure Managed Lustre file system xxx.
# Keyword: 

---
# What is Azure Managed Lustre (Preview)?

<!--STATUS: Source content compiled from existing Private Preview overviews. Links not added. Organization needs work. Product team to review for needed content.-->

The Azure Managed Lustre service gives you the capability to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.

Lustre is an open-source parallel file system that can scale to massive storage sizes while also providing high performance throughput. It's used by the world's fastest supercomputers and in data-centric workflows for a variety of industries.  

Learn more about Lustre at [https://www.lustre.org](https://www.lustre.org).

Azure Managed Lustre saves you the work of provisioning, configuring, and managing your own Lustre system. With a simple "create" experience in the Azure Pportal, you can quickly deploy a right-sized Lustre file system in less than half an hour, connect your clients, and be ready to go. 

Azure Blob storage is integrated with Azure Managed Lustre, so you can specify which files you want to import from a blob container for use in your Lustre file system. Blob Storage integration is an application of Lustre hierarchical storage management (HSM). There's no need to import your entire data set for every job when you can create a different file system for different jobs and store data in lower-cost Azure Blob containers between uses. You can export changed data to Blob storage when you're done, and delete the Azure Managed Lustre system.

## To join the public preview

IN DEVELOPMENT (2 sentences):

* About the public preview
* How to sign up
* Support policies

## Data security in Azure Managed Lustre

All data stored in Azure is encrypted at rest using Microsoft-managed keys by default. If you want to manage the keys used to encrypt your data when it's stored in your Azure Managed Lustre cluster, follow the instructions in [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

All information in an Azure Managed Lustre file system also is protected by VM host encryption on the managed disks that hold your data, even if you add a customer-managed key for the Lustre disks. Adding a customer-managed key gives an extra level of security for customers with high security needs. For more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

## Data resilience in Azure Managed Lustre

<!--Source: Azure Managed Lustre system properties - fs-properties.md-->

When you create an Azure Managed Lustre file system, the resulting cloud-based Lustre system is preconfigured for you based on the storage size and throughput values you chose. 

You can see some of the properties in the file system overview page on the Azure portal. Click the **JSON view** link for more details. 

[ADD SCREENSHOT: Summary & detail]

## Data disks

Your Azure Managed Lustre file system uses Azure managed disks as object storage target (OST) data disks. 

All Azure Managed Lustre file systems that are created as "durable" file system type use Azure Premium SSD (solid state drive) disks configured as locally redundant storage (LRS). LRS disk contents are replicated three times within the local data center to protect against drive and server rack failures. This redundancy provides 99.99999% durability.

Of course, tThe Lustre file system itself also contributes to data resilience with the object storage processes it uses to store data on these disks. 

If you need regional or global data redundancy, you can use the blob integration and archive feature to regularly export files from your Azure Managed Lustre file system to a long-term blob storage container that has a different redundancy policy. Configure blob storage redundancy at the storage account level. You can choose zonal (ZRS) or global (GRS) data redundancy when you create the storage account. Learn more about blob storage redundancy options.

## Azure Blob Storage integration

<!--Source: Use Azure Blob Storage with Azure Managed Lustre - Will be included in the public preview docs.-->

Azure Managed Lustre is customized to work seamlessly with Azure Blob Storage. You can specify a populated blob container to make its data accessible from your Azure Managed Lustre file system, or specify an empty container that you populate with data or use to store your output. All of the setup and maintenance is done for you - you just need to specify thewhich blob container to use.

Integrating Blob Storage at when you create the Lustre file system is optional, but it's the only way to use Lustre Hierarchical Storage Management (HSM) features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

Read the Lustre HSM documentation - GET LINK - to learn more about how Lustre HSM works.

## Use Azure Managed Lustre for Kubernetes containers

<!--Source: Use the Azure Lustre CSI Driver (Preview) for Kubernetes-->

If you want to use an Azure Managed Lustre storage system with Kubernetes containers, you can use the Azure Lustre container support interface (CSI) driver for Kubernetes. 

The driver is compatible with Azure Kubernetes Service (AKS) - GET LINK. Other Kubernetes installations are currently not supported; contact the Azure Managed Lustre team at the email address above for more information.

To find out compatible Kubernetes versions, see Azure Lustre CSI Driver for Kubernetes in the driver repository README.

## Use Azure Managed Lustre with Kubernetes (Private Preview)

<!--Recast to coordinate this section with the previous one.-->

Kubernetes can simplify the process to configure and deploy virtual client endpoints for your Azure Managed Lustre workload. It can automate setup tasks like these:

* Create virtual machine scale sets (VMSS) used by AKS to run the pods.

* Load the correct Lustre client software onto the VM instances.

* Specify the Azure Managed Lustre mount point, and propagate that information to the client pods.

The Azure Lustre CSI Driver can automate installing the client software and mounting drives. The driver provides a CSI controller plugin as a deployment with two replicas, by default, and a CSI node plugin as a daemonset.
