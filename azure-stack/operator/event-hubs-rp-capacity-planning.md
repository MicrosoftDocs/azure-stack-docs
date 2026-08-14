---
title: Plan capacity for Event Hubs on Azure Stack Hub
description: Learn how to plan capacity for Azure Event Hubs on Azure Stack Hub by setting quotas and calculating resource consumption. Start planning your deployment today.
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: how-to
ms.date: 07/08/2026
ms.reviewer: jfggdl
ms.lastreviewed: 08/15/2020
---

# How to do capacity planning for Azure Event Hubs on Azure Stack Hub

As an operator, you manage your Azure Stack Hub capacity by setting [quotas](azure-stack-quota-types.md) on resources. You control Event Hubs resource consumption by setting quotas on the maximum number of cores that Event Hubs clusters can use. Users create Event Hubs clusters when they deploy an Event Hubs resource. This article also covers various resource consumption requirements for the resource provider.

## Cluster resource consumption

Users create Event Hubs clusters based on Capacity Units (CUs). They don't specify a CPU core count when creating an Event Hubs cluster. However, every CU directly maps to a specific number of cores consumed. 

Your users need to create Event Hubs clusters with CUs that meet their business requirements. To set quota configuration, review the following table for:

- The total cores used by a 1 CU Event Hubs cluster.
- The approximate capacity required for consumption of other resources, including VM storage, memory, and storage accounts.

| | VM type | Cluster nodes | Cores per VM/node | Total cores | VM storage | Memory | Storage accounts | Public IPs |
|-|---------|-------|-------------------|-------------|------------|--------|------------------|---|
| **1 CU Event Hubs cluster** | [D11_V2](../user/azure-stack-vm-sizes.md#dv2-series) | 5 | 2 | 10 | 500 GiB | 70 GiB | 4 | 1 |

All Event Hubs clusters use a [D11_V2](../user/azure-stack-vm-sizes.md#dv2-series) VM type for their nodes. A D11_V2 VM type consists of 2 cores. So 1 CU Event Hubs cluster uses 5 D11_V2 VMs, which translates into 10 cores used. When you determine the number of cores to configure for a quota, use a multiple of the total cores used by 1 CU. This calculation reflects the maximum CU count you allow your users to use when creating Event Hubs clusters. For example, to configure a quota that allows users to create a cluster with 2 CUs of capacity, set your quota at 20 cores.

[!INCLUDE [event-hubs-scale](../includes/event-hubs-scale.md)]

## Resource provider resource consumption  

The Event Hubs resource provider consumes a constant amount of resources, regardless of the number or sizes of clusters that users create. The following table shows the core utilization by the Event Hubs resource provider on Azure Stack Hub, and the approximate resource consumption by other resources. The Event Hubs resource provider uses a [D2_V2](../user/azure-stack-vm-sizes.md#dv2-series) VM type for its deployment.

|                                  | VM Type | Cluster Nodes | Cores | VM Storage | Memory | Storage Accounts | Public IPs |
|----------------------------------|---------|---------------|-------|------------|--------|------------------|------------|
| **Event Hubs resource provider** | D2_V2   | 3     | 6     | 300 GiB | 21 GiB | 2 | 1 |

> [!IMPORTANT]
> Quotas don't control resource provider consumption. You don't need to include the cores that the resource provider uses in your quota configurations. Use an administrator subscription to install resource providers. The subscription doesn't impose resource consumption limits on operators when they install their required resource providers.

## Total resource consumption

The total capacity that the Event Hubs service consumes includes resource consumption by the resource provider, and consumption by user-created clusters.

The following table shows the total Event Hubs consumption under various configurations, regardless of whether they're managed by quota. These numbers are based on the resource provider and Event Hubs cluster consumptions that the previous section presented. You can easily calculate your total Azure Stack Hub usage for other deployment sizes by using these examples.

|                                      | Cores | VM Storage | Memory  | Storage Accounts | Total Storage\* | Public IPs\*\* |
|--------------------------------------|-------|------------|---------|------------------|---------------|------------|
| **1-CU cluster + resource provider** | 16    | 800 GiB    | 91 GiB  | 6                | variable    | 2 |
| **2-CU cluster + resource provider** | 26    | 1.3 TB     | 161 GiB | 10               | variable    | 2 |
| **4-CU cluster + resource provider** | 46    | 2.3 TB     | 301 GiB | 18               | variable    | 2 |

\* The ingress data block (message or event) rate and message retention are two important factors that contribute to the storage used by Event Hubs clusters. For example, if message retention is set to seven days when creating an event hub, and messages are ingested at a rate of 1 MB/s, the approximate storage used is 604 GB (1 MB x 60 seconds x 60 minutes x 24 hours x 7 days). If messages are sent at a rate of 20 MB/s with a seven days retention, the approximate storage consumption is 12 TB. Be sure to consider ingress data rate and retention time to fully understand storage capacity consumption.

\*\* You consume public IP addresses from the [network quota provided as part of your subscription](azure-stack-quota-types.md#network-quota-types).

## Next steps

Before you begin the installation process, complete the [Prerequisites for installing Event Hubs on Azure Stack Hub](event-hubs-rp-prerequisites.md).
