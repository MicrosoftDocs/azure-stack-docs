---
title: Azure Stack HCI deployment overview
description: An overview of the Azure Stack HCI deployment process.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 05/28/2020
---

# Azure Stack HCI deployment overview

> Applies to: Azure Stack HCI, version 20H2

This topic provides a high-level, step-by-step overview of the Azure Stack HCI deployment process, with links to more detailed information.

## Step 1: Plan storage

Azure Stack HCI uses industry-standard servers with local-attached drives to create highly available, highly scalable software-defined storage. To meet your performance and capacity requirements, carefully [choose drives](../concepts/choose-drives.md) and [plan volumes](../concepts/plan-volumes.md).

## Step 2: Plan networking

Take note of the server names, domain names, RDMA protocols and versions, and VLAN ID for your deployment.

## Step 3: Plan multi-site clusters

If your Azure Stack HCI deployment will stretch across multiple sites, determine how many servers you will need at each site, and whether the cluster configuration will be active/passive or active/active.

## Step 4: Before you start

[Before you start](before-you-start.md), determine whether your hardware meets the base requirements for Azure Stack HCI. Then, install Windows Admin Center on a Windows 10 PC to manage your Azure Stack HCI cluster. 

## Step 5: Deploy the operating system

Deploy the Azure Stack HCI operating system on each server you want to cluster.

## Step 6: Validate the configuration

Before you create the cluster, it's a good idea to validate the configuration to make sure that the hardware and hardware settings are compatible with failover clustering. You must have at least two servers to run all tests. If you have only one node, many of the critical storage tests do not run.

The following example runs all cluster validation tests on computers that are named *Server1* and *Server2*.

```PowerShell
Test-Cluster –Node Server1, Server2
```

> [!NOTE]
> The **Test-Cluster** cmdlet outputs the results to a log file in the current working directory. For example: C:\Users\<username>\AppData\Local\Temp\

## Step 7: Create a failover cluster

Create a failover cluster using Windows Admin Center or Powershell.

## Step 8: Validate the cluster

After deploying a cluster, run the Validate-DCB tool to test networking, and use the Validate feature in Windows Admin Center by selecting **Tools > Servers > Inventory > Validate cluster**.

## Step 9: Deploy multi-site clusters

For native disaster recovery and business continuity, you can deploy a stretched cluster that spans two geographically separate sites.

## Step 10: Deploy workloads and connect to Azure

You are now ready to create virtual machines and deploy workloads on Azure Stack HCI. You can also connect your cluster to Azure for usage metering and additional services.

## Next steps

For related information, see also:

- [Deploy Storage Spaces Direct](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct)

