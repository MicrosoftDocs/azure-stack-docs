---
title: Azure Stack HCI deployment overview
description: An overview of the Azure Stack HCI deployment process.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.date: 07/21/2020
---

# What is the deployment process for Azure Stack HCI?

> Applies to: Azure Stack HCI, version 20H2

This topic provides a high-level, step-by-step overview of the Azure Stack HCI deployment process, with links to more detailed information.

## Plan

Before you deploy, carefully plan your storage, networking, and requirements for multi-site clustering.

### Plan storage

Azure Stack HCI uses industry-standard servers with local-attached drives to create highly available, highly scalable software-defined storage. To meet your performance and capacity requirements, carefully [choose drives](../concepts/choose-drives.md) and [plan volumes](../concepts/plan-volumes.md).

### Plan networking

Take note of the server names, domain names, RDMA protocols and versions, and VLAN ID for your deployment.

### Plan stretched clusters

If your Azure Stack HCI deployment will stretch across multiple sites, determine how many servers you will need at each site, and whether the cluster configuration will be active/passive or active/active. For more information, see [About stretched clusters](../concepts/stretched-clusters.md).

## Deploy

### 1. Before you start

Before you start, [determine whether your hardware meets the base requirements and gather information needed](before-you-start.md) for deploying Azure Stack HCI. Then, [install Windows Admin Center](/windows-server/manage/windows-admin-center/use/get-started) to manage your Azure Stack HCI cluster.

### 2. Deploy the operating system

Deploy the Azure Stack HCI [operating system](operating-system.md) on each server you want to cluster.

### 3. Create the cluster

Create a failover cluster using [Windows Admin Center](create-cluster.md) or [PowerShell](create-cluster-powershell.md). For native disaster recovery and business continuity, you can deploy a [stretched cluster](../concepts/stretched-clusters.md) that spans two geographically separate sites.

### 4. Create a cluster witness

[Setting up a witness resource](witness.md) is mandatory for all clusters. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline. 

### 5. Validate the cluster

After creating the cluster, [run cluster validation tests](validate.md) to catch hardware or configuration problems before a cluster goes into production.

### 6. Connect to Azure

Azure Stack HCI works best when regularly connected to Azure. To get started, [register your Windows Admin Center gateway](../manage/register-windows-admin-center.md) by going to the Azure tab in Windows Admin Center settings. Then, [register Azure Stack HCI](register-with-azure.md) with your Azure subscription. Users must connect to Azure a minimum of once a month in order for the number of processor cores to be assessed for billing purposes.

### 7. Deploy storage

[Create volumes](../manage/create-volumes.md) on a single-site cluster, or [create volumes and set up replication on a stretched cluster](../manage/create-stretched-volumes.md).

### 8. Deploy workloads

You are now ready to [create virtual machines](../manage/vm.md) and deploy workloads on Azure Stack HCI using Windows Admin Center.

## Next steps

For related information, see also:

- [Deploy Storage Spaces Direct](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct)
- [Manage Azure registration](../manage/manage-azure-registration.md)
