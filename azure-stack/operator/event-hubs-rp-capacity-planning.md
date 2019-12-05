---
title: How to do capacity planning for Event Hubs on Azure Stack Hub
description: Learn how to plan capacity for the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/18/2019
ms.reviewer: jfggdl
ms.lastreviewed: 11/18/2019
---

# How to do capacity planning for Event Hubs on Azure Stack Hub

As an Operator you manage your Azure Stack Hub capacity using [quotas](azure-stack-quota-types.md) on resources. For Event Hubs, you control resource consumption by setting quotas on the maximum number of cores utilized by Event Hub clusters. Event Hub clusters are created by users when they deploy an Event Hubs resource.

## Event Hubs cluster resource consumption

To understand capacity consumption of Event Hubs deployments, its important to note that users create Event Hubs clusters based on Capacity Units (CUs). They do not specify a CPU core count when creating an Event Hubs cluster. However, every CU directly maps to a specific number of cores consumed. 

Your users will need to create Event Hubs clusters with CUs that meet their business requirements. In order to inform your decision on quota configuration, the following table shows:
- The core utilization by a 1 CU Event Hubs cluster.
- The approximate consumption required for other resources.

| | VM Type | Nodes | Cores per VM/node | Total Cores | VM Storage | Memory | Storage Accounts |
|-|---------|-------|-------------------|-------------|------------|--------|------------------|
| **1 CU Event Hubs cluster** | [D11_V2](../user/azure-stack-vm-sizes.md#mo-dv2) | 5 | 2 | 10 | 500 GiB | 70 GiB | 4 |

All Event Hubs clusters use a [D11_V2](../user/azure-stack-vm-sizes.md#mo-dv2) VM type for their nodes. A D11_V2 VM type consists of 2 cores. So 1 CU Event Hubs cluster uses 5 D11_V2 VMs, which translates into 10 cores used. In determining the number of cores to configure for a quota, use a multiple of the total cores used by 1 CU. This reflects the maximum CU count you'll allow your users to use, when creating Event Hubs clusters. For example, if you want to configure a quota that allows users to create a cluster with 2 CUs of capacity, then you will need to set your quota at 20 cores.

> [!NOTE]
> **Public preview only** The available version of Event Hubs on Azure Stack Hub only supports the creation of 1 CU clusters. The General Availability (GA) version of Event Hubs will include support for different CU configuration options.

## Total resource consumption  

The total capacity consumed by the Event Hubs service includes the resource provider resource consumption, and consumption by the clusters created by users.

The resource consumption by the Event Hubs resource provider is constant, and independent of the number or sizes of clusters created by users. The following table shows the core utilization by the Event Hubs resource provider on Azure Stack Hub, and the approximate resource consumption by other resources. Please note that the Event Hubs resource provider uses a [D2_V2](/user/azure-stack-vm-sizes#dv2-series) VM type for its deployment.

|                                  | VM Type | Nodes | Cores | VM Storage | Memory | Storage Accounts |
|----------------------------------|---------|-------|-------|------------|--------|------------------|
| **Event Hubs resource provider** | D2_V2   | 3     | 6     | 300 GiB    | 21 GiB | 2                |

**Note:** The resource provider consumption is not something that is controlled by quotas. You do not need to use the number of cores used by the resource provider for your quota configurations. Resource providers are installed using an Admin subscription with no resource consumption limit to allow Operators to install services according to their needs.

The following table shows the total Event Hubs consumption under various configurations, regardless if they are managed by quota. These numbers are based on the resource provider and Event Hubs cluster consumptions presented above. You could easily calculate your total Azure Stack Hub usage for other deployment sizes, using these examples.

|                                      | Cores | VM Storage | Memory  | Storage Accounts | Total Storage |
|--------------------------------------|-------|------------|---------|------------------|---------------|
| **1-CU cluster + resource provider** | 16    | 800 GiB    | 91 GiB  | 6                | variable\*    |
| **2-CU cluster + resource provider** | 26    | 1.3 TB     | 161 GiB | 10               | variable\*    |
| **4-CU cluster + resource provider** | 46    | 2.3 TB     | 301 GiB | 18               | variable\*    |

\* The ingress data block (message/event) rate and message retention are two important factors that contribute to the amount of storage used by Event Hubs clusters. For example, if message retention is set to 7 days when creating an event hub, and messages are ingested at a rate of 1MB/s, then the approximate storage used is 604 GB (1 MB x 60 seconds x 60 minutes x 24 hours X 7 days). If
messages are sent at a rate of 20MB/s with a 7 days retention, then the approximate storage consumption is 12TB. Be sure to consider ingress data rate and retention time to fully understand storage capacity consumption.

## Next steps

Complete the [Prerequisites for installing Event Hubs on Azure Stack Hub](event-hubs-rp-prerequisites.md), before beginning the installation process.





