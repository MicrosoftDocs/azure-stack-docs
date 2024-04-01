---
title: MetalLB overview for Kubernetes clusters
description: Learn the basic concepts of MetalLB load balancing for AKS Arc Kubernetes clusters
ms.topic: conceptual
ms.date: 03/20/2024
author: HE-Xinyu
ms.author: xinyuhe
---

# Overview
When you set up your AKS Arc cluster, you need a way to make your services accessible outside the cluster. The `LoadBalancer` type is ideal for this, but you'll notice that the external IP remains pending. MetalLB Arc extension is a tool that allows you to generate external IPs for your applications and services. Arc enabled Kubernetes clusters can integrate with [MetalLB](https://metallb.universe.tf/configuration/) using `Arc Networking` k8s-extension.

MetalLB needs IP addresses to use for making your services accessible outside the cluster. MetalLB takes care of assigning and releasing these addresses as needed when you create services, but it will only distribute IPs that are in its configured pools. When MetalLB assigns an external IP address to a service, it needs to inform the network outside the cluster that this IP belongs to the cluster. This is done using standard network protocols like ARP or BGP. 

- Layer 2 mode (ARP): In layer 2 mode, one K8s node in the cluster takes ownership of the service, and uses standard address discovery protocols (ARP for IPv4) to make those IPs reachable on the local network. From the LAN’s point of view, the announcing machine simply has multiple IP addresses.
- BGP: In BGP mode, all machines in the cluster establish BGP peering sessions with nearby routers that you control, and tell those routers how to forward traffic to the service IPs. Using BGP allows for true load balancing across multiple nodes, and fine-grained traffic control thanks to BGP’s policy mechanisms.

MetalLB has two components:
- Controller: Responsible for allocating IP for each service of `type=loadbalancer`.
- Speaker: Responsible for advertising the IP using `ARP` or `BGP` protocol. To satisfy high availability (HA) requirement, the speaker deployment is a daemonset.

:::image type="content" source="media/load-balancer-overview/metallb-architecture.png" alt-text="MetalLB Architecture" lightbox="media/load-balancer-overview/metallb-architecture.png":::

![metallb-architecture](assets/metallb-architecture.png)

NOTE:
- Speaker pods use host network, i.e., their IP is the node IP, so that they can directly send broadcast messages via the host network interface.
- The controller pod is a normal pod that lives in any node in the cluster.

- In ARP mode, one of the speaker pods is selected as the leader. It then advertises the IP using ARP broadcast message, binding the IP with the MAC address of the node it lives in. Thus, all traffic will first hit one node, and then kube-proxy spreads it evenly to all the backend pods of the service.
- In BGP mode, all cluster nodes establish connection with all BGP peers created in the `BGP Peers` tab. Typically a BGP peer is a TOR switch. In order to broadcast the BGP routing information, the BGP peers need to be configured so that it recognizes the IP and ASN of cluster nodes. When using BGP with ECMP (Equal-Cost MultiPath), traffic will hit evenly across all nodes, and thus it achieves true load balancing.

# Comparison between MetalLB L2 (ARP) and BGP modes
Below is a general comparison. The choice between L2 and BGP mode with MetalLB depends on your specific requirements, network infrastructure, and deployment scenarios.
| Aspect                      | MetalLB in L2 (ARP) mode          | MetalLB in BGP mode            |
|-----------------------------|----------------------------------|----------------------------------|
| Overview | In layer 2 mode, one K8s node assumes the responsibility of advertising a service to the local network. From the network’s perspective, it simply looks like that K8s node has multiple IP addresses assigned to its network interface. | In BGP mode, each K8s node in your cluster establishes a BGP peering session with your network routers, and uses that peering session to advertise the IPs of external cluster services. |
| IP Address Assignment       | MetallLB IP address pools need to be in the same subnet as the K8s nodes.   | MetallLB IP address pools can be in a different network than the K8s nodes. |
| Configuration Complexity    | Low, since you're providing IP addresses in the same network as your Kubernetes nodes, you only need to specify an IP CIDR or IP pool while setting up MetalLB. | High - Configuring BGP requires knowledge of BGP protocol and understanding of your network infrastructure. |
| Scalability                 | Limited to Layer 2 networks, suitable for small to medium-sized K8s deployments. | Suitable for complex network topologies and large-scale K8s deployments. |
| Compatibility with infrastructure network | Works with any network, but can cause ARP flooding in large K8s clusters, since a single IP is used for all services, and the service’s ingress bandwidth is limited to the bandwidth of a single node. | Requires BGP support in the network infrastructure. |
| Traffic Engineering         | Limited control over traffic routing. | Fine-grained control over traffic routing using BGP attributes. |
| External Connectivity       | Requires additional configurations for external connectivity. | Provides seamless connectivity with external networks using BGP routing |

# Next steps
- [Deploy MetalLB load balancer using Azure portal]()
