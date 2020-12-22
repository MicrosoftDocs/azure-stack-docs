---
title: Stretched clusters overview
description: Learn about stretched clusters
author: v-dasis
ms.topic: how-to
ms.date: 12/21/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Stretched clusters overview

> Applies to Azure Stack HCI, version v20H2

An Azure Stack HCI stretched cluster solution for disaster recovery provides automatic failover to restore production quickly, and without the need for manual intervention. Storage Replica provides the replication of volumes across sites for disaster recovery, with all servers staying in sync.

Storage Replica supports both synchronous and asynchronous replication:

- Synchronous replication mirrors data across sites in a low-latency network with crash-consistent volumes to ensure zero data loss at the file-system level during a failure.
- Asynchronous replication mirrors data across sites beyond metropolitan ranges over network links with higher latencies, but without a guarantee that both sites have identical copies of the data at the time of a failure.

>[!NOTE]
> For asynchronous replication, you need to bring destination volumes in the other site online manually after failover. For more information, see [Asynchronous replication](https://docs.microsoft.com/windows-server/storage/storage-replica/storage-replica-overview#asynchronous-replication).

There are two types of stretched clusters, active-passive and active-active. You can set up active-passive site replication, where there is a preferred site and direction for replication. Active-active replication is where replication can happen bi-directionally from either site. This article covers the active/passive configuration only.

In simple terms, an *active* site is one that has resources and is providing roles and workloads for clients to connect to. A *passive* site is one that does not provide any roles or workloads for clients and is waiting for a failover from the active site for disaster recovery.

Sites can be in two different states, different cities, different floors, or different rooms. Stretched clusters using two sites provides disaster recovery and business continuity should a site suffer an outage or failure.

Take a few minutes to watch the video on stretched clustering with Azure Stack HCI:
> [!VIDEO https://www.youtube.com/embed/rYnZL1wMiqU]

## Active-passive stretched cluster

The following diagram shows Site 1 as the active site with replication to Site 2, a unidirectional replication.

:::image type="content" source="media/stretched-cluster/active-passive-stretched-cluster.png" alt-text="Active/passive stretched cluster scenario"  lightbox="media/stretched-cluster/active-passive-stretched-cluster.png":::

## Active-active stretched cluster

The following diagram shows both Site 1 and Site 2 as being active sites, with bidirectional replication to the other site.

:::image type="content" source="media/stretched-cluster/active-active-stretched-cluster.png" alt-text="Active/active stretched cluster scenario" lightbox="media/stretched-cluster/active-active-stretched-cluster.png":::

## Next steps

- Learn more about Storage Replica. See [Storage Replica overview](https://docs.microsoft.com/windows-server/storage/storage-replica/storage-replica-overview).
- Learn even more about using Storage Replica. See [Configure a Hyper-V Failover Cluster or a File Server for a General Use Cluster](https://docs.microsoft.com/windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#configure-a-hyper-v-failover-cluster-or-a-file-server-for-a-general-use-cluster).
- Learn about hardware and other requirements for stretched clusters. See [System requirements](system-requirements.md).
- Learn how to deploy a stretched cluster using Windows Admin Center. See [Create a cluster using Windows Admin Center](../deploy/create-cluster.md).
- Learn how to deploy a stretched cluster using PowerShell. See [Create a cluster using PowerShell](../deploy/create-cluster-powershell.md).
- Learn how to create volumes and set up replication for stretched clusters. See [Create volumes and set up replication for stretched clusters](../manage/create-stretched-volumes.md).
