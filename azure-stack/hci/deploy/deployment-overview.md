---
title: Azure Stack HCI deployment overview
description: An overview of the Azure Stack HCI deployment process.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/28/2020
---

# What is the deployment process for Azure Stack HCI?

> Applies to: Azure Stack HCI, version 20H2

This topic provides a high-level, step-by-step overview of the Azure Stack HCI deployment process, with links to more detailed information.

## Plan

Before you deploy, carefully plan your storage, networking, and requirements for multi-site clustering (if any).

### Plan storage

Azure Stack HCI uses industry-standard servers with local-attached drives to create highly available, highly scalable software-defined storage. To meet your performance and capacity requirements, carefully [choose drives](../concepts/choose-drives.md) and [plan volumes](../concepts/plan-volumes.md).

### Plan networking

Take note of the server names, domain names, RDMA protocols and versions, and VLAN ID for your deployment.

### Plan stretched clusters

If your Azure Stack HCI deployment will stretch across multiple sites, determine how many servers you will need at each site, and whether the cluster configuration will be active/passive or active/active. For more information, see [About stretched clusters](../concepts/stretched-clusters.md).

## Deploy

Before you deploy the OS, determine whether your hardware meets the [system requirements](../concepts/system-requirements.md) for Azure Stack HCI. Then, [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) to manage your Azure Stack HCI cluster.

### 1. Deploy Azure Stack HCI

[Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) and deploy the Azure Stack HCI [operating system](operating-system.md) on each server you want to cluster. If you've purchased Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://azure.microsoft.com/en-us/products/azure-stack/hci/catalog/) through your preferred Microsoft hardware partner, the Azure Stack HCI operating system should be pre-installed. In that case, you can skip this step and move on to #2.

### 2. Create the cluster

Create a failover cluster using [Windows Admin Center](create-cluster.md) or [PowerShell](create-cluster-powershell.md). For native disaster recovery and business continuity, you can deploy a [stretched cluster](../concepts/stretched-clusters.md) that spans two geographically separate sites.

### 3. Set up a cluster witness

[Setting up a witness resource](witness.md) is mandatory for all clusters. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline. 

### 4. Register with Azure

Azure Stack HCI requires a connection to Azure. To connect your cluster to Azure, see [register Azure Stack HCI with Azure](register-with-azure.md). Once registered, the cluster connects automatically in the background.

### 5. Validate the cluster

After creating and registering the cluster, [run cluster validation tests](validate.md) to catch hardware or configuration problems before the cluster goes into production.

### 6. Deploy storage

[Create volumes](../manage/create-volumes.md) on a single-site cluster, or [create volumes and set up replication on a stretched cluster](../manage/create-stretched-volumes.md).

### 7. Deploy workloads

You are now ready to [create virtual machines](../manage/vm.md) and deploy workloads on Azure Stack HCI using Windows Admin Center.

## Next steps

Learn how to deploy the Azure Stack HCI operating system.

> [!div class="nextstepaction"]
> [Deploy the Azure Stack HCI operating system](operating-system.md)
