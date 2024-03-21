---
title: Load Balancer in Arc Kubernetes
description: Learn the basic concepts of load balancers in Arc Kubernetes
ms.topic: conceptual
ms.date: 03/20/2024
author: HE-Xinyu
ms.author: xinyuhe
---

Arc Kubernetes Cluster integrates with [MetalLB](https://metallb.universe.tf/configuration/) to provide load balancer for any Arc-connected clusters. 

# MetalLB Architecture

MetalLB has two components:

- Controller: responsible for allocating IP for each service of `type=loadbalancer`.
- Speaker: responsible for advertising the IP using `ARP` or `BGP` protocol. To satisfy High Availability (HA) requirement, the speaker deployment is a daemonset.

:::image type="content" source="media/load-balancer-overview/metallb-architecture.png" alt-text="MetalLB Architecture" lightbox="media/load-balancer-overview/metallb-architecture.png":::

![metallb-architecture](assets/metallb-architecture.png)

NOTE:

- Speaker pods use host network, i.e., their IP is the node IP, so that they can directly send broadcast messages via the host network interface.
- The controller pod is a normal pod that lives in any node in the cluster.

To advertise service IP to outside world, MetalLB uses a network protocol to broadcast the IP. Currently MetalLB supports two protocols: `ARP (L2)` and `BGP`.

## ARP mode

In ARP mode, one of the speaker pods is selected as the leader. It then advertises the IP using ARP broadcast message, binding the IP with the MAC address of the node it lives in. Thus, all traffic will first hit one node, and then kube-proxy spreads it evenly to all the backend pods of the service.

## BGP Mode

In BGP mode, all cluster nodes establish connection with all BGP peers created in the `BGP Peers` tab. Typically a BGP peer is a TOR switch. In order to broadcast the BGP routing information, the BGP peers need to be configured so that it recognizes the IP and ASN of cluster nodes.

When using BGP with ECMP (Equal-cost multipath), traffic will hit evenly across all nodes, and thus it achieves true load balancing.
