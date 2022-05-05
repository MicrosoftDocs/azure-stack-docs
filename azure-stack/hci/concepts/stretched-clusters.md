---
title: Stretched clusters overview
description: Learn about stretched clusters
author: v-jamemurray
ms.topic: how-to
ms.date: 12/21/2020
ms.author: v-jamemurray
ms.reviewer: johnmar
---

# Stretched clusters overview

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

An Azure Stack HCI stretched cluster solution for disaster recovery provides automatic failover to restore production quickly, and without the need for manual intervention. Storage Replica provides the replication of volumes across sites for disaster recovery, with all servers staying in sync.

Storage Replica supports both synchronous and asynchronous replication:

- Synchronous replication mirrors data across sites in a low-latency network with crash-consistent volumes to ensure zero data loss at the file-system level during a failure.
- Asynchronous replication mirrors data across sites beyond metropolitan ranges over network links with higher latencies, but without a guarantee that both sites have identical copies of the data at the time of a failure.

>[!NOTE]
> For asynchronous replication, you need to bring destination volumes in the other site online manually after failover. For more information, see [Asynchronous replication](/windows-server/storage/storage-replica/storage-replica-overview#asynchronous-replication).

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

## Guest IP failover considerations

When talking about stretch clustering, one of the considerations that must be accounted for are the virtual machines and the IP addresses being used. Datacenters that reside in different locations generally have different IP subnets. The IP addresses the virtual machines use would be good for one datacenter but unreachable in another. Therefore, planning how to deal with IP address changes must be accounted for. For the most part, there are four different ways to handle changing the IP address on the virtual machine on failover. There may be others, but this document will cover the top four.

The first and easiest is the use of DHCP. When moving a virtual machine from one site to another, one step that it will do is request a DHCP address. This will obtain the proper IP Address for the proper site it is in as long as a DHCP server is available.

Next, there is the use of a static address. However, unlike Hyper-V Replica, there is not a way to specify an alternate IP address. Therefore, a script will need to be created to assign the proper IP address for the VM depending on which site it is on. For example, SiteA uses a 1.x network and SiteB uses a 156.x network. This script would need to detect the network the virtual machine is on and set a 1.x IP address scheme if it is in SiteA or a 156.x IP address scheme if it is in SiteB. The Domain Name Services (DNS) will also need to be made aware of the change and replicated between the sites.

Another option is the use of an intermediary network device that will provide a single IP address for the virtual machine for client connectivity which can route the traffic to the virtual machine to the site it is currently on. Clients and DNS will always have the same address for the virtual machine, and the intermediary device would need to track the actual IP address and location of the virtual machine so that clients are directed to the virtual machine appropriately.

The last option is the use of a stretched vLAN. With a stretched vLAN, virtual machines can keep the same IP address no matter the site it is on. However, due to some of the complexities of configuring and maintaining a stretched vLAN, this option is not recommended by Microsoft.

With any of the above options, additional considerations (DNS, ARP caches, TTL, etc.) need to be accounted for when it comes to client connectivity and must be thoroughly thought out.  Please work with your networking team to identify the best option to meet your needs. 

## Next steps

- Learn more about Storage Replica. See [Storage Replica overview](/windows-server/storage/storage-replica/storage-replica-overview).
- Learn even more about using Storage Replica. See [Configure a Hyper-V Failover Cluster or a File Server for a General Use Cluster](/windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#configure-a-hyper-v-failover-cluster-or-a-file-server-for-a-general-use-cluster).
- Learn about hardware and other requirements for stretched clusters. See [System requirements](system-requirements.md).
- Learn how to deploy a stretched cluster using Windows Admin Center. See [Create a cluster using Windows Admin Center](../deploy/create-cluster.md).
- Learn how to deploy a stretched cluster using PowerShell. See [Create a cluster using PowerShell](../deploy/create-cluster-powershell.md).
- Learn how to create volumes and set up replication for stretched clusters. See [Create volumes and set up replication for stretched clusters](../manage/create-stretched-volumes.md).
