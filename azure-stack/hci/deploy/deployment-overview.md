---
title: Azure Stack HCI deployment overview
description: An overview of the Azure Stack HCI deployment process.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 06/03/2020
---

# Azure Stack HCI deployment overview

> Applies to: Azure Stack HCI, version 20H2

This topic provides a high-level, step-by-step overview of the Azure Stack HCI deployment process, with links to more detailed information.

## Plan

Before you deploy, carefully plan your storage, networking, and requirements for multi-site clustering.

### Plan storage

Azure Stack HCI uses industry-standard servers with local-attached drives to create highly available, highly scalable software-defined storage. To meet your performance and capacity requirements, carefully [choose drives](../concepts/choose-drives.md) and [plan volumes](../concepts/plan-volumes.md).

### Plan networking

Take note of the server names, domain names, RDMA protocols and versions, and VLAN ID for your deployment.

### Plan stretched clusters

If your Azure Stack HCI deployment will stretch across multiple sites, determine how many servers you will need at each site, and whether the cluster configuration will be active/passive or active/active.

## Deploy

1. Before you start

[Before you start](before-you-start.md), determine whether your hardware meets the base requirements for Azure Stack HCI. Then, install Windows Admin Center to manage your Azure Stack HCI cluster. 

2. Deploy the operating system

Deploy the Azure Stack HCI operating system on each server you want to cluster.

3. Create the cluster

Create a failover cluster using Windows Admin Center or Powershell. For native disaster recovery and business continuity, you can deploy a stretched cluster that spans two geographically separate sites.

4. Validate the cluster

After creating the cluster, run the Validate-DCB tool to test networking, and use the Validate feature in Windows Admin Center by selecting **Tools > Servers > Inventory > Validate cluster**.

The following example runs all cluster validation tests on computers that are named *Server1* and *Server2*.

```PowerShell
Test-Cluster –Node Server1, Server2
```

> [!NOTE]
> The **Test-Cluster** cmdlet outputs the results to a log file in the current working directory. For example: C:\Users\<username>\AppData\Local\Temp\

5. Connect to Azure

Part of the value of Azure Stack HCI is the ability to connect to Azure for additional services. First, register Windows Admin Center with Azure. Then register Azure Stack HCI with the Azure Stack HCI Azure service. Users must connect to Azure from time to time in order for core usage to be assessed for billing purposes.

6. Deploy storage

[Create volumes](../manage/create-volumes.md) on a single-site cluster, or create volumes, pools, and replication groups on a stretched cluster.

7. Deploy workloads

You are now ready to create virtual machines on Azure Stack HCI using Windows Admin Center.

## Next steps

For related information, see also:

- [Deploy Storage Spaces Direct](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct)

